import React from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import LoginScreen from '../screens/LoginScreen';
import HouseholdDashboard from '../screens/HouseholdDashboard';
import AddExpenseScreen from '../screens/AddExpenseScreen';
import { useAuthContext } from '../context/AuthContext';

const Stack = createNativeStackNavigator();

export default function AppNavigator() {
  const { user } = useAuthContext();

  return (
    <Stack.Navigator>
      {user ? (
        <>
          <Stack.Screen name="HouseholdDashboard" component={HouseholdDashboard} options={{ title: 'My Household' }} />
          <Stack.Screen name="AddExpense" component={AddExpenseScreen} options={{ title: 'Add Expense' }} />
        </>
      ) : (
        <Stack.Screen name="Login" component={LoginScreen} options={{ headerShown: false }} />
      )}
    </Stack.Navigator>
  );
}
