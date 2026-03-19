-- Create a function to delete the authenticated user's account
-- This function will be called from the app when a user wants to delete their account
-- It deletes the user from auth.users, which will cascade delete all related data

CREATE OR REPLACE FUNCTION delete_user()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    user_id_to_delete UUID;
BEGIN
    -- Get the current user's ID
    user_id_to_delete := auth.uid();

    -- Check if user is authenticated
    IF user_id_to_delete IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    -- Delete the user from auth.users
    -- This will cascade delete all related records due to foreign key constraints
    DELETE FROM auth.users WHERE id = user_id_to_delete;

    -- If we get here, the deletion was successful
    -- No explicit return needed for void function
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION delete_user() TO authenticated;

-- Add comment to function
COMMENT ON FUNCTION delete_user() IS 'Allows authenticated users to delete their own account. Cascades to all related data.';
