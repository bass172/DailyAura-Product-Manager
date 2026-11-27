import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "AIzaSyCazQt-6AHNcaPqO_0_CABsBy3nM4hFTQc",
  authDomain: "daulyaura.firebaseapp.com",
  projectId: "daulyaura",
  storageBucket: "daulyaura.firebasestorage.app",
  messagingSenderId: "221836237448",
  appId: "1:221836237448:web:f2b088c70297458d439d3d"
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
