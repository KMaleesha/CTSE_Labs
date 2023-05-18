import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';

import Home from './screens/Main';
import Detail from './screens/UpdateToDo';
import LoginScreen from "./screens/Login";


const Stack = createStackNavigator()

export default function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator screenOptions={{headerShown: false}}>
        <Stack.Screen 
          name='LoginScreen' 
          component={LoginScreen} 
        />
                <Stack.Screen name={'Home'} component={Home} />
   
        <Stack.Screen 
          name='Detail'
          component={Detail}
        />
      </Stack.Navigator>
    </NavigationContainer>
  );
}

