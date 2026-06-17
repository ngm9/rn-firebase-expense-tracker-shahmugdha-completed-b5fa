import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  Alert,
  ActivityIndicator,
} from 'react-native';
import { getAuth } from 'firebase/auth';
import { collection, addDoc, getDocs, query, where, serverTimestamp } from 'firebase/firestore';
import { db } from '../config/firebase';

export default function AddExpenseScreen({ navigation }) {
  const [description, setDescription] = useState('');
  const [amount, setAmount] = useState('');
  const [category, setCategory] = useState('');
  const [loading, setLoading] = useState(false);

  const handleAdd = async () => {
    const parsedAmount = parseFloat(amount);
    if (!description || isNaN(parsedAmount) || parsedAmount <= 0 || !category) {
      Alert.alert('Validation Error', 'Please fill in all fields with valid values.');
      return;
    }

    setLoading(true);
    try {
      const auth = getAuth();
      const uid = auth.currentUser?.uid;

      const householdSnap = await getDocs(
        query(collection(db, 'households'), where('memberIds', 'array-contains', uid))
      );

      if (householdSnap.empty) {
        Alert.alert('Error', 'No household found for this user.');
        setLoading(false);
        return;
      }

      await addDoc(collection(db, 'expenses'), {
        description,
        amount: parsedAmount,
        category,
        settled: false,
        createdAt: serverTimestamp(),
      });

      navigation.goBack();
    } catch (err) {
      Alert.alert('Error', 'Failed to add expense. Please try again.');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.label}>Description</Text>
      <TextInput style={styles.input} value={description} onChangeText={setDescription} placeholder="e.g. Groceries" />
      <Text style={styles.label}>Amount ($)</Text>
      <TextInput style={styles.input} value={amount} onChangeText={setAmount} placeholder="e.g. 45.00" keyboardType="decimal-pad" />
      <Text style={styles.label}>Category</Text>
      <TextInput style={styles.input} value={category} onChangeText={setCategory} placeholder="e.g. Food, Utilities" />
      {loading ? (
        <ActivityIndicator size="large" color="#4A90E2" style={{ marginTop: 20 }} />
      ) : (
        <TouchableOpacity style={styles.button} onPress={handleAdd}>
          <Text style={styles.buttonText}>Add Expense</Text>
        </TouchableOpacity>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 24, backgroundColor: '#f9f9f9' },
  label: { fontSize: 14, fontWeight: '600', marginBottom: 6, color: '#333' },
  input: { borderWidth: 1, borderColor: '#ccc', borderRadius: 8, padding: 12, marginBottom: 20, fontSize: 16, backgroundColor: '#fff' },
  button: { backgroundColor: '#4A90E2', padding: 14, borderRadius: 8, alignItems: 'center', marginTop: 8 },
  buttonText: { color: '#fff', fontSize: 16, fontWeight: '600' },
});
