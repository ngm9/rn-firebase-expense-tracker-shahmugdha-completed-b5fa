import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  FlatList,
  TouchableOpacity,
  StyleSheet,
  ActivityIndicator,
} from 'react-native';
import { getAuth } from 'firebase/auth';
import { collection, query, where, getDocs } from 'firebase/firestore';
import { db } from '../config/firebase';
import ExpenseItem from '../components/ExpenseItem';

export default function HouseholdDashboard({ navigation }) {
  const [expenses, setExpenses] = useState([]);
  const [householdName, setHouseholdName] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const auth = getAuth();
    const uid = auth.currentUser?.uid;

    const fetchData = async () => {
      try {
        const householdSnap = await getDocs(
          query(collection(db, 'households'), where('memberIds', 'array-contains', uid))
        );

        if (householdSnap.empty) {
          setLoading(false);
          return;
        }

        const householdDoc = householdSnap.docs[0];
        setHouseholdName(householdDoc.data().name);

        const expensesSnap = await getDocs(
          query(collection(db, 'expenses'), where('settled', '==', false))
        );

        const list = expensesSnap.docs.map((d) => ({ id: d.id, ...d.data() }));
        setExpenses(list);
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  if (loading) {
    return (
      <View style={styles.centered}>
        <ActivityIndicator size="large" color="#4A90E2" />
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Text style={styles.heading}>{householdName}</Text>
      <Text style={styles.subheading}>Unsettled Expenses</Text>
      <FlatList
        data={expenses}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => <ExpenseItem expense={item} />}
        ListEmptyComponent={<Text style={styles.empty}>No unsettled expenses found.</Text>}
      />
      <TouchableOpacity
        style={styles.fab}
        onPress={() => navigation.navigate('AddExpense')}
      >
        <Text style={styles.fabText}>+ Add Expense</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f9f9f9', padding: 16 },
  centered: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  heading: { fontSize: 24, fontWeight: '700', color: '#1a1a2e', marginBottom: 4 },
  subheading: { fontSize: 14, color: '#666', marginBottom: 16 },
  empty: { textAlign: 'center', color: '#999', marginTop: 40, fontSize: 15 },
  fab: { backgroundColor: '#4A90E2', padding: 14, borderRadius: 50, alignItems: 'center', marginTop: 16 },
  fabText: { color: '#fff', fontSize: 16, fontWeight: '600' },
});
