package ru.ipo.kio._11.VirtualPhysics.virtual_physics
{
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.utils.ByteArray;

import mx.controls.Label;
import mx.controls.TextInput;

//Класс работающий с файлами
	public class FileManager
	{
		//Имя файла по умолчанию
		private static const DEFAULT_FILE_NAME:String = "result.txt";
		//Маска файла по умолчанию
		private static const FILE_TYPES:Array = [new FileFilter("Text File", "*.txt;*.text")];
		//Внутренние переменные
		private var F1:TextInput;
		private var F2:TextInput;
		private var F3:TextInput;
		private var result1:Label;
		private var result2:Label;
		private var result3:Label;
		private var fr:FileReference;
		public function FileManager() 
		{
			
		}
		//Метод загрузки данных из файла(асинхронный)
		public function loadFromFile(inF1:TextInput,
									 inF2:TextInput,
									 inF3:TextInput,
									 inresult1:Label,
									 inresult2:Label,
									 inresult3:Label):void {
			
			F1 = inF1;
			F2 = inF2;
			F3 = inF3;
			result1= inresult1;
			result2 = inresult2;
			result3= inresult3;
			//create the FileReference instance
			fr = new FileReference();

			//listen for when they select a file
			fr.addEventListener(Event.SELECT, onFileSelect);

			//listen for when then cancel out of the browse dialog
			fr.addEventListener(Event.CANCEL,onCancel);

			//open a native browse dialog that filters for text files
			fr.browse(FILE_TYPES);

			
			
		}
		
		//Метод сохранения данных в файл(асинхронный)
		public function saveToFile(F1:String,
								   F2:String,
								   F3:String,
								   result1:String,
								   result2:String,
								   result3:String):void {
				//create the FileReference instance
				fr = new FileReference();

				//listen for the file has been saved
				fr.addEventListener(Event.COMPLETE, onFileSave);

				//listen for when then cancel out of the save dialog
				fr.addEventListener(Event.CANCEL,onCancel);

				//listen for any errors that occur while writing the file
				fr.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);

				//open a native save file dialog, using the default file name
				var savingtext:String = F1 + "\n" + F2 + "\n" + F3 + "\n" + result1 + "\n" + result2 + "\n" + result3;
				fr.save(savingtext, DEFAULT_FILE_NAME);
						   
		}
			//called once the file has been saved
			private function onFileSave(e:Event):void
			{
				trace("File Saved");
				fr = null;
			}

			//called if the user cancels out of the file save dialog
			private function onCancel(e:Event):void
			{
				trace("File save select canceled.");
				fr = null;
			}

			//called if an error occurs while saving the file
			private function onSaveError(e:IOErrorEvent):void
			{
				trace("Error Saving File : " + e.text);
				fr = null;
			}
			
			//called when the user selects a file from the browse dialog
			private function onFileSelect(e:Event):void
			{
				//listen for when the file has loaded
				fr.addEventListener(Event.COMPLETE, onLoadComplete);

				//listen for any errors reading the file
				fr.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);

				//load the content of the file
				fr.load();
			}

			//called when the user cancels out of the browser dialog
			

			/************ Select Event Handlers **************/

			//called when the file has completed loading
			private function onLoadComplete(e:Event):void
			{
				//get the data from the file as a ByteArray
				var data:ByteArray = fr.data;

				//read the bytes of the file as a string and put it in the
				//textarea
				var str:String = data.readUTFBytes(data.bytesAvailable);
				
				var res:Array = str.split("\n");
				F1.text = res[0];
				F2.text = res[1];
				F3.text = res[2];
				result1.text = res[3];
				result2.text = res[4];
				result3.text = res[5];
				
				fr = null;
			}

			//called if an error occurs while loading the file contents
			private function onLoadError(e:IOErrorEvent):void
			{
				trace("Error loading file : " + e.text);
			}


	}

}