import firebase from 'firebase/compat/app';
import 'firebase/compat/auth';
import 'firebase/compat/firestore';

const firebaseConfig = {
    apiKey: "AIzaSyCOJZy-2jkgGWJkE5p9NYjngiCEpf2ij5U",
    authDomain: "todoapps-5fbc2.firebaseapp.com",
    projectId: "todoapps-5fbc2",
    storageBucket: "todoapps-5fbc2.appspot.com",
    messagingSenderId: "272545184647",
    appId: "1:272545184647:web:bbe5a1f77f699a17207122",
    measurementId: "272545184647"
  };

if (!firebase.apps.length) {
    firebase.initializeApp(firebaseConfig);
}

export { firebase };

const auth = firebase.auth();

export { auth };