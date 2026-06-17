import { db } from '../config/firebase';
import { collection, getDocs, query, where } from 'firebase/firestore';

export async function fetchUserHousehold(uid) {
  const snap = await getDocs(
    query(collection(db, 'households'), where('memberIds', 'array-contains', uid))
  );
  if (snap.empty) return null;
  const doc = snap.docs[0];
  return { id: doc.id, ...doc.data() };
}
