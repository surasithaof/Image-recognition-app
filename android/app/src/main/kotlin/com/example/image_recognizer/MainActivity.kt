package com.example.image_recognizer
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity()
{

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }



    override fun onStart() {

        super.onStart()
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL).setMethodCallHandler {
//            call,result ->

//            if(call.method == "imageProcess") {
//                val imageBytes = call.arguments<ByteArray>();
//                try {
//                    val bitmapImage =
//                        BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes!!.size);
//                    Log.d("BITMAP","Bitmap data ${bitmapImage.toString()}",)
//                    val tensorImage = TensorImage.fromBitmap(bitmapImage);
//                    val inputBuffer: ByteBuffer = imageProcessor.process(tensorImage).buffer;
//                    result.success(inputBuffer)
//                } catch (exception: Exception) {
//                    Log.d("IM Error","Failed", exception)
//                    result.error("Error","Image process failed",exception);
//                }
//            }  if(call.method == "imageProcess") {
//                val imageBytes = call.arguments<ByteArray>();
//                try {
//                    val bitmapImage =
//                        BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes!!.size);
//                    Log.d("BITMAP","Bitmap data ${bitmapImage.toString()}",)
//                    val tensorImage = TensorImage.fromBitmap(bitmapImage);
//                    val inputBuffer: ByteBuffer = imageProcessor.process(tensorImage).buffer;
//                    result.success(inputBuffer)
//                } catch (exception: Exception) {
//                    Log.d("IM Error","Failed", exception)
//                    result.error("Error","Image process failed",exception);
//                }
//            }
//
//            if(call.method == "loadMLModel") {
//                val modelBytes =  call.arguments<ByteArray>()
//                if(modelBytes!=null) {
//                   val status = imageRecognizer.initializeModel(this);
//                    result.success(status);
//                } else {
//                    result.success(false);
//                }
//            }
//
//
//
//
//
//            if(call.method == "generateVector") {
//                val imageBitMap =  call.arguments<ByteArray>();
//                System.out.println( "imageBytes -----" +imageBitMap.toString());
//                if(imageBitMap!=null) {
//                    val bitmapImage = BitmapFactory.decodeByteArray(imageBitMap, 0, imageBitMap.size);
//                    val floatArrayResult  = imageRecognizer.recognizableArrayGenerator(bitmapImage);
//                    result.success(floatArrayResult);
//                } else {
//                    result.error("Error","null bitmap received",null)
//                }
//
//            }


//        }

    }


}
