import 'package:flutter/material.dart';
import 'package:mess/register_login/email.dart';
import 'package:mess/studentpages/studenthomepg.dart';

class Homepg extends StatefulWidget {
  const Homepg({super.key});

  @override
  State<Homepg> createState() => _HomepgState();
}

class _HomepgState extends State<Homepg> {
  String roll='';
  String pass='';
  final TextEditingController textEditingController1=TextEditingController();
  final TextEditingController textEditingController2=TextEditingController();
  assign(){
    setState(() {
      roll=textEditingController1.text;
      pass=textEditingController2.text;
    });  
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const border=OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(0, 0, 0, 1),
      ),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );
    
    return Scaffold(
      body: Container(
        decoration:const  BoxDecoration(
          image: DecorationImage(
            image:  AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
            ),
        ),
        padding: const EdgeInsets.only(left:20,right: 20),
        child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                const SizedBox(height:125),
                const Center(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Login with your credentials',
                  style:Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: textEditingController1,
                  style:Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical:10,horizontal:10),
                    labelText: 'Roll Number',
                    hintText: 'Ex: B2XXXX',
                    labelStyle:Theme.of(context).textTheme.titleMedium,
                    border:border,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: textEditingController2,
                  style:Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical:10,horizontal:10),
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline,color: Color.fromARGB(255, 36, 27, 173),),
                    labelStyle:Theme.of(context).textTheme.titleMedium,
                    border:border,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                      return const Emailid();
                    }));
                  },
                  child: Text('Forgot Password?',
                    style:Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ElevatedButton(
                  style:ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    elevation: 20,
                    backgroundColor:const Color.fromARGB(255, 44, 7, 251),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    assign();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                    return const Studenthomepage();
                    }));
                  },
                  child: const Text('Login',
                    style:TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Don’t have an account?',
                      style:Theme.of(context).textTheme.bodySmall,
                    ),
                    TextButton(
                      onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                      return const Emailid();
                    }));
                  },
                      child: Text('Register', style:Theme.of(context).textTheme.titleSmall,),
                    ),
                  ],
                ),
              ],
            ),
      ),
    );
  }
}