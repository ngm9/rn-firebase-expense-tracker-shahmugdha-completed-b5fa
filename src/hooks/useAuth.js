import { useState, useEffect } from 'react';
import { getAuth } from 'firebase/auth';

export function useAuth() {
  const auth = getAuth();
  const [user, setUser] = useState(auth.currentUser);

  useEffect(() => {
    setUser(auth.currentUser);
  }, []);

  return { user, loading: false };
}
