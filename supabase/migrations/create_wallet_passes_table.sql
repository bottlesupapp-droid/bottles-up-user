-- Create wallet_passes table for storing Apple Wallet pass information
CREATE TABLE IF NOT EXISTS wallet_passes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    booking_id UUID NOT NULL,
    pass_type TEXT NOT NULL CHECK (pass_type IN ('rsvp', 'table_booking')),
    event_name TEXT NOT NULL,
    venue_name TEXT NOT NULL,
    event_date TIMESTAMP WITH TIME ZONE NOT NULL,
    event_time TEXT NOT NULL,
    qr_code_data TEXT,
    verification_code TEXT,
    table_number TEXT,
    party_size INTEGER,
    pass_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX idx_wallet_passes_user_id ON wallet_passes(user_id);
CREATE INDEX idx_wallet_passes_event_id ON wallet_passes(event_id);
CREATE INDEX idx_wallet_passes_booking_id ON wallet_passes(booking_id);
CREATE INDEX idx_wallet_passes_pass_type ON wallet_passes(pass_type);

-- Create unique constraint to prevent duplicate passes
CREATE UNIQUE INDEX idx_wallet_passes_unique ON wallet_passes(booking_id, pass_type);

-- Enable Row Level Security
ALTER TABLE wallet_passes ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
-- Users can view their own wallet passes
CREATE POLICY "Users can view their own wallet passes"
    ON wallet_passes
    FOR SELECT
    USING (auth.uid() = user_id);

-- Users can insert their own wallet passes
CREATE POLICY "Users can insert their own wallet passes"
    ON wallet_passes
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Users can update their own wallet passes
CREATE POLICY "Users can update their own wallet passes"
    ON wallet_passes
    FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Users can delete their own wallet passes
CREATE POLICY "Users can delete their own wallet passes"
    ON wallet_passes
    FOR DELETE
    USING (auth.uid() = user_id);

-- Create trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_wallet_passes_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER wallet_passes_updated_at
    BEFORE UPDATE ON wallet_passes
    FOR EACH ROW
    EXECUTE FUNCTION update_wallet_passes_updated_at();

-- Grant necessary permissions
GRANT ALL ON wallet_passes TO authenticated;
GRANT USAGE ON SEQUENCE wallet_passes_id_seq TO authenticated;

-- Add comment to table
COMMENT ON TABLE wallet_passes IS 'Stores Apple Wallet pass information for event bookings and RSVPs';
