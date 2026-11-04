-- ====================================================================
-- FOGONAZO OS - CREAR / RESTABLECER USUARIOS DE ACCESO (SUPERADMIN Y DUEÑO DEMO)
-- Pega este script en el SQL Editor de Supabase y pulsa "Run"
-- ====================================================================

BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;

DO $$
DECLARE
  v_superadmin_id UUID;
  v_dueno_id UUID;
BEGIN
  -- 1. SUPERADMIN: admin@fogonazo.es / Contraseña: Fogonazo2026!
  SELECT id INTO v_superadmin_id FROM auth.users WHERE email = 'admin@fogonazo.es' LIMIT 1;

  IF v_superadmin_id IS NULL THEN
    v_superadmin_id := gen_random_uuid();
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      v_superadmin_id,
      'authenticated',
      'authenticated',
      'admin@fogonazo.es',
      extensions.crypt('Fogonazo2026!', extensions.gen_salt('bf')),
      NOW(),
      '{"provider":"email","providers":["email"]}'::jsonb,
      '{"nombre":"Superadmin Fogonazo"}'::jsonb,
      NOW(), NOW(), '', '', '', ''
    );

    INSERT INTO auth.identities (
      id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at
    ) VALUES (
      gen_random_uuid(),
      v_superadmin_id,
      v_superadmin_id::text,
      jsonb_build_object('sub', v_superadmin_id::text, 'email', 'admin@fogonazo.es', 'email_verified', true, 'phone_verified', false),
      'email',
      NOW(), NOW(), NOW()
    );
  ELSE
    UPDATE auth.users
    SET encrypted_password = extensions.crypt('Fogonazo2026!', extensions.gen_salt('bf')),
        email_confirmed_at = COALESCE(email_confirmed_at, NOW()),
        updated_at = NOW()
    WHERE id = v_superadmin_id;
  END IF;

  INSERT INTO public.perfiles (user_id, rol, restaurante_id, nombre)
  VALUES (v_superadmin_id, 'superadmin', NULL, 'Superadmin Fogonazo')
  ON CONFLICT (user_id) DO UPDATE
  SET rol = 'superadmin', restaurante_id = NULL, nombre = 'Superadmin Fogonazo';


  -- 2. DUEÑO DEMO: cocina@lafogoneta.es / Contraseña: Demo2026!
  SELECT id INTO v_dueno_id FROM auth.users WHERE email = 'cocina@lafogoneta.es' LIMIT 1;

  IF v_dueno_id IS NULL THEN
    v_dueno_id := gen_random_uuid();
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
      created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token
    ) VALUES (
      '00000000-0000-0000-0000-000000000000',
      v_dueno_id,
      'authenticated',
      'authenticated',
      'cocina@lafogoneta.es',
      extensions.crypt('Demo2026!', extensions.gen_salt('bf')),
      NOW(),
      '{"provider":"email","providers":["email"]}'::jsonb,
      '{"nombre":"Gerente La Fogoneta"}'::jsonb,
      NOW(), NOW(), '', '', '', ''
    );

    INSERT INTO auth.identities (
      id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at
    ) VALUES (
      gen_random_uuid(),
      v_dueno_id,
      v_dueno_id::text,
      jsonb_build_object('sub', v_dueno_id::text, 'email', 'cocina@lafogoneta.es', 'email_verified', true, 'phone_verified', false),
      'email',
      NOW(), NOW(), NOW()
    );
  ELSE
    UPDATE auth.users
    SET encrypted_password = extensions.crypt('Demo2026!', extensions.gen_salt('bf')),
        email_confirmed_at = COALESCE(email_confirmed_at, NOW()),
        updated_at = NOW()
    WHERE id = v_dueno_id;
  END IF;

  INSERT INTO public.perfiles (user_id, rol, restaurante_id, nombre)
  VALUES (v_dueno_id, 'dueno', 'rest_demo', 'Gerente La Fogoneta')
  ON CONFLICT (user_id) DO UPDATE
  SET rol = 'dueno', restaurante_id = 'rest_demo', nombre = 'Gerente La Fogoneta';

END $$;

COMMIT;

-- Mostrar los usuarios configurados
SELECT u.email, p.rol, p.restaurante_id, p.nombre
FROM auth.users u
JOIN public.perfiles p ON p.user_id = u.id;

