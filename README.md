**Create user_roles table in Supabase**
```
CREATE TABLE user_roles (
     id UUID REFERENCES auth.users(id) PRIMARY KEY,
     role TEXT NOT NULL CHECK (role IN ('superadmin', 'staff'))
   );

   -- Grant access to the table
   ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;
   CREATE POLICY "Users can view their own role" ON user_roles
     FOR SELECT USING (auth.uid() = id);
```

**Get the user IDs**
`SELECT id FROM auth.users WHERE email IN ('jindalsumit1991@gmail.com', 'mehar.mrd@gmail.com');`

**Insert roles for these users**
```
INSERT INTO user_roles (id, role)
VALUES 
  ((SELECT id FROM auth.users WHERE email = 'jindalsumit1991@gmail.com'), 'superadmin'),
  ((SELECT id FROM auth.users WHERE email = 'mehar.mrd@gmail.com'), 'staff');
```
