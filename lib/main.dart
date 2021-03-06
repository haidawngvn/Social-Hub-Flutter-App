import 'package:endterm/providers/user_provider.dart';
import 'package:endterm/responsive/mobile_screen_layout.dart';
import 'package:endterm/responsive/responsive_layout.dart';
import 'package:endterm/responsive/web_screen_layout.dart';
import 'package:endterm/views/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:endterm/constants/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb){
    await Firebase.initializeApp(
        options: const FirebaseOptions(         //lúc tạo web app trên firebase sẽ đc cung cấp cái này
            apiKey: 'AIzaSyBpgYdaQULiNgONN1JGkFko6eP9wmDSCpI',
            appId: '1:564771532215:web:2f43d41be689dcbee70c32',
            messagingSenderId: '564771532215',
            projectId: 'endterm-group9',
            storageBucket: 'endterm-group9.appspot.com')
    );
  }
  else{
    await Firebase.initializeApp();
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('darkMode');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Social Hub',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          //userChanges() thì sẽ được gọi mỗi khi user sign in, sign out,thay nổi password,email, ...
          //idTokenChanges() thì sẽ được gọi mỗi khi user sign in, sign out,... điểm trừ là nếu ng dùng cài app đó 
          //lên máy khác(apk) thì app đó sẽ ghi nhớ luôn phiên đăng nhập trong máy trước
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active){    //active là check xem đã kết nối đc tới stream ở trên hay chưa
              if (snapshot.hasData){
                return const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              }
              else if (snapshot.hasError){
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
    
            if (snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(color: Colors.white,),
              );
            }
    
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}

// // Import the functions you need from the SDKs you need
// import { initializeApp } from "firebase/app";
// // TODO: Add SDKs for Firebase products that you want to use
// // https://firebase.google.com/docs/web/setup#available-libraries

// // Your web app's Firebase configuration
// const firebaseConfig = {
//   apiKey: "AIzaSyBpgYdaQULiNgONN1JGkFko6eP9wmDSCpI",
//   authDomain: "endterm-group9.firebaseapp.com",
//   projectId: "endterm-group9",
//   storageBucket: "endterm-group9.appspot.com",
//   messagingSenderId: "564771532215",
//   appId: "1:564771532215:web:2f43d41be689dcbee70c32"
// };

// // Initialize Firebase
// const app = initializeApp(firebaseConfig);