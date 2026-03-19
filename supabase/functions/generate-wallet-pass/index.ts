import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface PassData {
  event_id: string;
  user_id: string;
  booking_id: string;
  pass_type: "rsvp" | "table_booking";
  event_name: string;
  venue_name: string;
  event_date: string;
  event_time: string;
  qr_code_data?: string;
  verification_code?: string;
  table_number?: string;
  party_size?: number;
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Get the authorization header
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      throw new Error("No authorization header");
    }

    // Create Supabase client
    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
      {
        global: {
          headers: { Authorization: authHeader },
        },
      }
    );

    // Verify user is authenticated
    const {
      data: { user },
      error: userError,
    } = await supabaseClient.auth.getUser();

    if (userError || !user) {
      throw new Error("Unauthorized");
    }

    // Parse request body
    const passData: PassData = await req.json();

    // Validate required fields
    if (
      !passData.event_id ||
      !passData.booking_id ||
      !passData.event_name ||
      !passData.venue_name
    ) {
      throw new Error("Missing required fields");
    }

    // Generate the Apple Wallet pass JSON
    const pass = generatePassJson(passData);

    // In a production environment, you would:
    // 1. Sign the pass with your Apple Developer certificate
    // 2. Create the .pkpass file (ZIP archive with manifest and signature)
    // 3. Upload to Supabase Storage
    // 4. Return the public URL

    // For now, we'll create a simple pass JSON and store it
    const passFileName = `${passData.booking_id}_${Date.now()}.json`;

    // Upload to Supabase Storage
    const { data: uploadData, error: uploadError } =
      await supabaseClient.storage
        .from("wallet-passes")
        .upload(passFileName, JSON.stringify(pass), {
          contentType: "application/json",
          upsert: false,
        });

    if (uploadError) {
      throw new Error(`Failed to upload pass: ${uploadError.message}`);
    }

    // Get public URL
    const {
      data: { publicUrl },
    } = supabaseClient.storage.from("wallet-passes").getPublicUrl(passFileName);

    return new Response(
      JSON.stringify({
        success: true,
        pass_url: publicUrl,
        message: "Wallet pass generated successfully",
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      }
    );
  } catch (error) {
    console.error("Error generating wallet pass:", error);
    return new Response(
      JSON.stringify({
        success: false,
        error: error.message,
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 400,
      }
    );
  }
});

/**
 * Generate Apple Wallet Pass JSON structure
 * Note: This is a simplified version. In production, you need:
 * - Apple Developer account
 * - Pass Type ID
 * - Team ID
 * - Certificate for signing
 */
function generatePassJson(data: PassData): any {
  const eventDate = new Date(data.event_date);
  const formattedDate = eventDate.toLocaleDateString("en-US", {
    weekday: "short",
    year: "numeric",
    month: "short",
    day: "numeric",
  });

  return {
    formatVersion: 1,
    passTypeIdentifier: "pass.com.bottlesup.event", // Replace with your actual Pass Type ID
    serialNumber: data.booking_id,
    teamIdentifier: "YOUR_TEAM_ID", // Replace with your Apple Team ID
    organizationName: "Bottles Up",
    description: `${data.pass_type === "rsvp" ? "Event RSVP" : "Table Reservation"} - ${data.event_name}`,

    // Branding
    logoText: "Bottles Up",
    foregroundColor: "rgb(255, 255, 255)",
    backgroundColor: "rgb(255, 107, 0)", // Orange theme
    labelColor: "rgb(255, 255, 255)",

    // Event ticket specific fields
    eventTicket: {
      primaryFields: [
        {
          key: "event",
          label: "EVENT",
          value: data.event_name,
        },
      ],
      secondaryFields: [
        {
          key: "date",
          label: "DATE",
          value: formattedDate,
        },
        {
          key: "time",
          label: "TIME",
          value: data.event_time,
        },
      ],
      auxiliaryFields: [
        {
          key: "venue",
          label: "VENUE",
          value: data.venue_name,
        },
        ...(data.table_number
          ? [
              {
                key: "table",
                label: "TABLE",
                value: data.table_number,
              },
            ]
          : []),
        ...(data.party_size
          ? [
              {
                key: "guests",
                label: "GUESTS",
                value: `${data.party_size}`,
              },
            ]
          : []),
      ],
      backFields: [
        {
          key: "booking_id",
          label: "Booking ID",
          value: data.booking_id,
        },
        ...(data.verification_code
          ? [
              {
                key: "verification",
                label: "Verification Code",
                value: data.verification_code,
              },
            ]
          : []),
        {
          key: "type",
          label: "Ticket Type",
          value:
            data.pass_type === "rsvp"
              ? "Guestlist RSVP"
              : "Table Reservation",
        },
        {
          key: "terms",
          label: "Terms & Conditions",
          value:
            "Please present this pass at the venue entrance. Valid ID required.",
        },
      ],
    },

    // Barcode for check-in
    ...(data.qr_code_data && {
      barcode: {
        message: data.qr_code_data,
        format: "PKBarcodeFormatQR",
        messageEncoding: "iso-8859-1",
        altText: data.booking_id,
      },
    }),

    // Relevant date/time
    relevantDate: eventDate.toISOString(),

    // Locations (if available, you could add venue coordinates)
    // locations: [
    //   {
    //     latitude: 0.0,
    //     longitude: 0.0,
    //     relevantText: data.venue_name,
    //   },
    // ],
  };
}
