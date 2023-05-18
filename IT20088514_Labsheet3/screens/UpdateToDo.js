import React, { useState } from "react";
import { View, TextInput, StyleSheet, Text, Pressable } from "react-native";
import { firebase } from "../config";
import { useNavigation } from "@react-navigation/native";

const UpdateToDo = ({ route }) => {
  const todoRef = firebase.firestore().collection("todos");
  const [textHeading, onChangeHeadingText] = useState(route.params.item.name);
  const navigation = useNavigation();

  const updateTodo = () => {
    if (textHeading && textHeading.length > 1) {
      todoRef
        .doc(route.params.item.id)
        .update({
          heading: textHeading,
        })
        .then(() => {
            alert("Update ToDo successfully");
          navigation.navigate("Home");
        })
        .catch((error) => {
          alert(error.message);
        });
    }
  };

  return (
    <View style={styles.container}>
          <Text style={{
        fontSize: 40,
        fontWeight: "600",
        textAlign: "center",
        color: "#D93DE7",
        marginTop: "35%",
        marginBottom: "5%"
      }}>
       Update ToDo App 
      </Text>
      <TextInput
         
        style={styles.textfield}
        onChangeText={onChangeHeadingText}
        value={textHeading}
        placeholder="Update Todo"
      />
      <Pressable
        style={styles.buttonUpdate}
        onPress={() => {
          updateTodo();
        }}
      >
        <Text>UPDATE TODO</Text>
      </Pressable>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginTop: 80,
    marginLeft: 15,
    marginRight: 15,
  },
  textfield: {
    marginBottom: 10,
    padding: 10,
    fontSize: 15,
    color: "#000000",
    backgroundColor: "#E7D1EE",
    borderRadius: 5,
  },
  buttonUpdate: {
    marginTop: 25,
    alignItems: "center",
    justifyContent: "center",
    paddingVertical: 12,
    paddingHorizontal: 32,
    borderRadius: 4,
    elevation: 10,
    backgroundColor: "#B744E4",
  },
});

export default UpdateToDo;
