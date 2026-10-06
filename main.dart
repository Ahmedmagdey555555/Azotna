import 'package:flutter/material.dart';
import 'core/api_client.dart';

void main()=>runApp(const AzotnaCustomer());

class AzotnaCustomer extends StatelessWidget{
  const AzotnaCustomer({super.key});
  @override Widget build(BuildContext c)=>MaterialApp(
    debugShowCheckedModeBanner:false,title:'عزوتنا',
    theme:ThemeData(useMaterial3:true,colorSchemeSeed:Colors.deepOrange),
    home:const Home());
}

class Home extends StatelessWidget{
  const Home({super.key});
  @override Widget build(BuildContext c)=>Directionality(
    textDirection:TextDirection.rtl,
    child:Scaffold(
      appBar:AppBar(title:const Text('عزوتنا')),
      body:ListView(padding:const EdgeInsets.all(16),children:[
        const Text('اطلب اللي محتاجه من أي مكان',style:TextStyle(fontSize:24,fontWeight:FontWeight.bold)),
        const SizedBox(height:8),
        const Text('مطاعم • سوبر ماركت • صيدليات • متاجر'),
        const SizedBox(height:18),
        _tile(c,'🍔','مطاعم'),
        _tile(c,'🛒','سوبر ماركت'),
        _tile(c,'💊','صيدليات'),
        _tile(c,'🛍️','متاجر'),
        Card(child:ListTile(
          leading:const Text('📦',style:TextStyle(fontSize:28)),
          title:const Text('طلب خاص'),
          subtitle:const Text('اطلب من أي محل أو مكان حتى لو خارج منطقتك'),
          onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const SpecialOrderPage())),
        )),
      ])));
  }

  Widget _tile(BuildContext c,String icon,String title)=>Card(
    child:ListTile(leading:Text(icon,style:const TextStyle(fontSize:28)),
      title:Text(title),trailing:const Icon(Icons.chevron_left)));
}

class SpecialOrderPage extends StatefulWidget{
  const SpecialOrderPage({super.key});
  @override State<SpecialOrderPage> createState()=>_SpecialOrderState();
}
class _SpecialOrderState extends State<SpecialOrderPage>{
  final api=ApiClient();
  final pickup=TextEditingController();
  final drop=TextEditingController();
  final notes=TextEditingController();
  String result='';

  Future<void> submit() async {
    try{
      final r=await api.post('/special-orders',{
        'customerId':'CURRENT_CUSTOMER',
        'pickupAddress':pickup.text,
        'pickupLat':27.18,'pickupLng':31.18,
        'dropoffAddress':drop.text,
        'dropoffLat':27.19,'dropoffLng':31.19,
        'requestedText':notes.text
      });
      setState(()=>result='تم إنشاء الطلب: ${r['id']}');
    }catch(e){setState(()=>result='تعذر إنشاء الطلب الآن');}
  }

  @override Widget build(BuildContext c)=>Directionality(
    textDirection:TextDirection.rtl,
    child:Scaffold(appBar:AppBar(title:const Text('طلب خاص')),
      body:ListView(padding:const EdgeInsets.all(16),children:[
        const Text('مكان الاستلام',style:TextStyle(fontWeight:FontWeight.bold)),
        TextField(controller:pickup,decoration:const InputDecoration(hintText:'اسم المحل أو العنوان')),
        const SizedBox(height:12),
        const Text('مكان التسليم',style:TextStyle(fontWeight:FontWeight.bold)),
        TextField(controller:drop,decoration:const InputDecoration(hintText:'العنوان أو القرية/المركز')),
        const SizedBox(height:12),
        const Text('عايز إيه؟',style:TextStyle(fontWeight:FontWeight.bold)),
        TextField(controller:notes,maxLines:4,decoration:const InputDecoration(hintText:'اكتب الطلب بالتفصيل')),
        const SizedBox(height:16),
        OutlinedButton.icon(onPressed:(){},icon:const Icon(Icons.camera_alt),label:const Text('إضافة صورة / روشتة')),
        const SizedBox(height:16),
        FilledButton(onPressed:submit,child:const Text('إرسال الطلب')),
        if(result.isNotEmpty) Padding(padding:const EdgeInsets.only(top:16),child:Text(result))
      ])));
}
