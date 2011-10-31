/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 22.04.11
 * Time: 17:07
 */
package ru.ipo.kio._11.checker {
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;

import flash.printing.PrintJobOptions;

import flash.text.StyleSheet;
import flash.text.TextFieldAutoSize;

import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import mx.graphics.codec.PNGEncoder;

import com.adobe.serialization.json.JSON;

import flash.display.BitmapData;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.errors.IOError;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.printing.PrintJob;
import flash.text.TextField;
import flash.utils.ByteArray;

import mx.core.BitmapAsset;

import ru.ipo.kio.api.TextUtils;
import ru.ipo.kio.base.displays.ShellButton;

public class CertificateView extends Sprite {

    private var WELCOME_MESSAGE:String = "<p class='h1' align='center'>Нажмите на любое место экрана, чтобы загрузить сертификат</p>";
    private var LOADING_MESSAGE:String = "<p align='center' class='red'>Загрузка...</p>";

    [Embed(source="resources/Sertificat_007.png")]
    private static var WITH_RANK_M:Class;
    private var IMG_RANK_M:BitmapAsset = new WITH_RANK_M;

    [Embed(source="resources/Sertificat_008.png")]
    private static var WITH_RANK_F:Class;
    private var IMG_RANK_F:BitmapAsset = new WITH_RANK_F;

    [Embed(source="resources/Sertificat_009.png")]
    private static var NO_RANK_M:Class;
    private var IMG_NO_RANK_M:BitmapAsset = new NO_RANK_M;

    [Embed(source="resources/Sertificat_010.png")]
    private static var NO_RANK_F:Class;
    private var IMG_NO_RANK_F:BitmapAsset = new NO_RANK_F;

    [Embed(source="resources/Sertificat_011.png")]
    private static var TEACHER_F:Class;
    private var IMG_TEACHER_F:BitmapAsset = new TEACHER_F;

    [Embed(source="resources/Sertificat_012.png")]
    private static var TEACHER_M:Class;
    private var IMG_TEACHER_M:BitmapAsset = new TEACHER_M;

    [Embed(systemFont="Arial", fontName="KioArial", embedAsCFF = "false", fontWeight="bold", mimeType="application/x-font")]
    private static var ARIAL_FONT:Class;

    [Embed(systemFont="Arial", fontName="KioArial", embedAsCFF = "false", fontStyle="italic", fontWeight="bold", mimeType="application/x-font")]
    private static var ARIAL_IT_FONT:Class;

    [Embed(
            source='resources/AmbassadoreType.ttf',
            embedAsCFF = "false",
            fontName="KioAmbassadore",
            mimeType="application/x-font-truetype",
            unicodeRange = "U+0000-U+FFFF"
            )]
    private static var AMBASSADORE_FONT:Class;

    [Embed(
            source='resources/AmbassadoreType Italic.Ttf',
            embedAsCFF = "false",
            fontStyle = "italic",
            fontName="KioAmbassadore",
            mimeType="application/x-font-truetype",
            unicodeRange = "U+0000-U+FFFF"
            )]
    private static var AMBASSADORE_BD_FONT:Class;

    private static var TEST_CERT_F_N:String = '{"json_certificate":"{\\"_level\\":2,\\"semiramida\\":{\\"pipesLength\\":216,\\"rooms\\":209},\\"digit\\":{\\"elements\\":1,\\"recognized\\":8},\\"digit_scores\\":25,\\"physics_scores\\":277,\\"_rank\\":108,\\"_anketa\\":{\\"second_name\\":\\"НИКОЛАЕВНА\\",\\"grade\\":\\"21\\",\\"name\\":\\"КРИСТИНА\\",\\"email\\":\\"It-mggtk@mail.ru\\",\\"surname\\":\\"БЕРЕЗНИКОВА\\",\\"inst_name\\":\\"МГГТК АГУ\\",\\"address\\":\\"р. Адыгея, г.Майкоп, ул. 2-ая Ветеранов 1\\"},\\"_login\\":\\"bereznikova421\\",\\"semiramida_scores\\":60,\\"physics\\":{\\"other_half\\":\\"0\\",\\"center_distance\\":\\"29.01\\",\\"one_ball\\":\\"3\\"},\\"_scores\\":362}","signature":717561}';
    private static var TEST_CERT_M_N:String = '{"json_certificate":"{\\"_level\\":2,\\"semiramida\\":{\\"pipesLength\\":216,\\"rooms\\":209},\\"digit\\":{\\"elements\\":1,\\"recognized\\":8},\\"digit_scores\\":25,\\"physics_scores\\":277,\\"_rank\\":108,\\"_anketa\\":{\\"second_name\\":\\"НИКОЛАЕВИЧ\\",\\"grade\\":\\"21\\",\\"name\\":\\"КРИСТИН\\",\\"email\\":\\"It-mggtk@mail.ru\\",\\"surname\\":\\"БЕРЕЗНИКОВ\\",\\"inst_name\\":\\"МГГТК АГУ\\",\\"address\\":\\"р. Адыгея, г.Майкоп, ул. 2-ая Ветеранов 1\\"},\\"_login\\":\\"bereznikova421\\",\\"semiramida_scores\\":60,\\"physics\\":{\\"other_half\\":\\"0\\",\\"center_distance\\":\\"29.01\\",\\"one_ball\\":\\"3\\"},\\"_scores\\":362}","signature":717561}';
    private static var TEST_CERT_F_R:String = '{"json_certificate":"{\\"_level\\":2,\\"semiramida\\":{\\"pipesLength\\":216,\\"rooms\\":209},\\"digit\\":{\\"elements\\":1,\\"recognized\\":8},\\"digit_scores\\":25,\\"physics_scores\\":277,\\"_rank\\":58,\\"_anketa\\":{\\"second_name\\":\\"НИКОЛАЕВНА\\",\\"grade\\":\\"21\\",\\"name\\":\\"КРИСТИНА\\",\\"email\\":\\"It-mggtk@mail.ru\\",\\"surname\\":\\"БЕРЕЗНИКОВА\\",\\"inst_name\\":\\"МГГТК АГУ\\",\\"address\\":\\"р. Адыгея, г.Майкоп, ул. 2-ая Ветеранов 1\\"},\\"_login\\":\\"bereznikova421\\",\\"semiramida_scores\\":60,\\"physics\\":{\\"other_half\\":\\"0\\",\\"center_distance\\":\\"29.01\\",\\"one_ball\\":\\"3\\"},\\"_scores\\":362}","signature":717561}';
    private static var TEST_CERT_M_R:String = '{"json_certificate":"{\\"_level\\":2,\\"semiramida\\":{\\"pipesLength\\":216,\\"rooms\\":209},\\"digit\\":{\\"elements\\":1,\\"recognized\\":8},\\"digit_scores\\":25,\\"physics_scores\\":277,\\"_rank\\":68,\\"_anketa\\":{\\"second_name\\":\\"НИКОЛАЕВИЧ\\",\\"grade\\":\\"21\\",\\"name\\":\\"КРИСТИН\\",\\"email\\":\\"It-mggtk@mail.ru\\",\\"surname\\":\\"БЕРЕЗНИКОВ\\",\\"inst_name\\":\\"МГГТК АГУ\\",\\"address\\":\\"р. Адыгея, г.Майкоп, ул. 2-ая Ветеранов 1\\"},\\"_login\\":\\"bereznikova421\\",\\"semiramida_scores\\":60,\\"physics\\":{\\"other_half\\":\\"0\\",\\"center_distance\\":\\"29.01\\",\\"one_ball\\":\\"3\\"},\\"_scores\\":362}","signature":717561}';
    private static var TEST_CERT_T_F:String = '{"json_certificate":"{\\"_level\\":2,\\"_position\\":\\"Очень серьезный организатор\\\\nВ очень серьезной организации\\",\\"_is_teacher\\":true,\\"semiramida\\":{\\"pipesLength\\":216,\\"rooms\\":209},\\"digit\\":{\\"elements\\":1,\\"recognized\\":8},\\"digit_scores\\":25,\\"physics_scores\\":277,\\"_rank\\":68,\\"_anketa\\":{\\"second_name\\":\\"НИКОЛАЕВНА\\",\\"grade\\":\\"21\\",\\"name\\":\\"КРИСТИНА\\",\\"email\\":\\"It-mggtk@mail.ru\\",\\"surname\\":\\"БЕРЕЗНИКОВА\\",\\"inst_name\\":\\"МГГТК АГУ\\",\\"address\\":\\"р. Адыгея, г.Майкоп, ул. 2-ая Ветеранов 1\\"},\\"_login\\":\\"bereznikova421\\",\\"semiramida_scores\\":60,\\"physics\\":{\\"other_half\\":\\"0\\",\\"center_distance\\":\\"29.01\\",\\"one_ball\\":\\"3\\"},\\"_scores\\":362}","signature":717561}';
    private static var TEST_CERT_T_M:String = '{"json_certificate":"{\\"_level\\":2,\\"_position\\":\\"Очень серьезный организатор\\\\nВ очень серьезной организации\\",\\"_is_teacher\\":true,\\"semiramida\\":{\\"pipesLength\\":216,\\"rooms\\":209},\\"digit\\":{\\"elements\\":1,\\"recognized\\":8},\\"digit_scores\\":25,\\"physics_scores\\":277,\\"_rank\\":68,\\"_anketa\\":{\\"second_name\\":\\"НИКОЛАЕВИЧ\\",\\"grade\\":\\"21\\",\\"name\\":\\"КРИСТИН\\",\\"email\\":\\"It-mggtk@mail.ru\\",\\"surname\\":\\"БЕРЕЗНИКОВ\\",\\"inst_name\\":\\"МГГТК АГУ\\",\\"address\\":\\"р. Адыгея, г.Майкоп, ул. 2-ая Ветеранов 1\\"},\\"_login\\":\\"bereznikova421\\",\\"semiramida_scores\\":60,\\"physics\\":{\\"other_half\\":\\"0\\",\\"center_distance\\":\\"29.01\\",\\"one_ball\\":\\"3\\"},\\"_scores\\":362}","signature":717561}';
    private static var TEST_CERT_LNG:String = '{"json_certificate":"{\\"_level\\":2,\\"_position\\":\\"Очень серьезный организатор\\\\nВ очень серьезной организации\\",\\"_is_teacher\\":true,\\"semiramida\\":{\\"pipesLength\\":216,\\"rooms\\":209},\\"digit\\":{\\"elements\\":1,\\"recognized\\":8},\\"digit_scores\\":25,\\"physics_scores\\":277,\\"_rank\\":68,\\"_anketa\\":{\\"second_name\\":\\"НИКОЛАЕВИЧЕВИЧ\\",\\"grade\\":\\"21\\",\\"name\\":\\"КРИСТИНИАН\\",\\"email\\":\\"It-mggtk@mail.ru\\",\\"surname\\":\\"БЕРЕЗНИКОВАШВИЛИЦЫКСОН\\",\\"inst_name\\":\\"МГГТК АГУ\\",\\"address\\":\\"р. Адыгея, г.Майкоп, ул. 2-ая Ветеранов 1\\"},\\"_login\\":\\"bereznikova421\\",\\"semiramida_scores\\":60,\\"physics\\":{\\"other_half\\":\\"0\\",\\"center_distance\\":\\"29.01\\",\\"one_ball\\":\\"3\\"},\\"_scores\\":362}","signature":717561}';

    private static var DEBUG_MODE:String = null;

    //embed signatures
    [Embed(source="resources/bmp-signatures/bashmakov.png")]
    private static var BASHMAKOV_SIGN:Class;
    private var IMG_BASHMAKOV:BitmapData = (new BASHMAKOV_SIGN).bitmapData;

    [Embed(source="resources/bmp-signatures/pozdnkov.png")]
    private static var POZDNKOV_SIGN:Class;
    private var IMG_POZDNKOV:BitmapData = (new POZDNKOV_SIGN).bitmapData;

    [Embed(source="resources/bmp-signatures/romanovsky.png")]
    private static var ROMANOVSKY_SIGN:Class;
    private var IMG_ROMANOVSKY:BitmapData = (new ROMANOVSKY_SIGN).bitmapData;

    [Embed(source="resources/bmp-signatures/terekhov.png")]
    private static var TEREKHOV_SIGN:Class;
    private var IMG_TEREKHOV:BitmapData = (new TEREKHOV_SIGN).bitmapData;

    private static const BUTTONS_LEFT:int = 4;
    private static const BUTTONS_SKIP:int = 10;
    private static const BUTTONS_TOP:int = 4;

    //buttons panel
    private var buttonsPanel:Sprite;
    private var slider:Slider;

    //welcome panel
    private var welcomePanel:Sprite;
    private var helloTextField:TextField;

    //certificate panel
    private var certificatePanel:Sprite;
    private var img:BitmapData = null;

    private var topHeight:int;

    private var certificateFile:FileReference;

    private static const certColor:uint = 0xbfdbff;
    private static const certLightColor:uint = 0xdfedff;

    public function CertificateView() {
        if (!stage)
            addEventListener(Event.ADDED_TO_STAGE, init);
        else
            init();
    }

    private function init(event:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        stage.addEventListener(Event.RESIZE, placeElement);

        //draw a rectangle
        graphics.beginFill(certLightColor);
        graphics.drawRect(0, 0, 8000, 8000);
        graphics.endFill();

        createButtonsPanel();
        createCertificatePanel();
        createWelcomePanel();

        placeElement();

        addChild(welcomePanel);
        stage.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
            trace(event.stageX, event.stageY, event.localX, event.localY);
        });
    }

    private function createCertificatePanel():void {
        certificatePanel = new Sprite;
        certificatePanel.x = 0;
        certificatePanel.y = topHeight;
        certificatePanel.addEventListener(MouseEvent.MOUSE_DOWN, certificateMouseDown);
        stage.addEventListener(MouseEvent.MOUSE_UP, certificateMouseUp);
        stage.addEventListener(MouseEvent.MOUSE_WHEEL, certificateMouseWheel);

        makeWhiteTransparent(IMG_BASHMAKOV);
        makeWhiteTransparent(IMG_POZDNKOV);
        makeWhiteTransparent(IMG_ROMANOVSKY);
        makeWhiteTransparent(IMG_TEREKHOV);
    }

    private function certificateMouseWheel(event:MouseEvent):void {
        certificatePanel.y += 10 * event.delta;
        rescaleCertificate();
    }

    private function certificateMouseDown(event:Event):void {
//        var span:Number = Math.max(0, certificatePanel.height - stage.stageHeight + topHeight);
//        certificatePanel.startDrag(false, new Rectangle(certificatePanel.x, buttonsPanel.height - span, 0, span));
        trace('certificate panel x', certificatePanel.x);
        trace('cph', certificatePanel.height);
        trace('topHeight - cph / 2', topHeight - certificatePanel.height / 2);
        trace('sh - th', stage.stageHeight - topHeight);
        certificatePanel.startDrag(false, new Rectangle(
                certificatePanel.x,
            //2 * (topHeight + stage.stageHeight) / 3 - certificatePanel.height,
                minY(),
                0,
            //certificatePanel.height - (topHeight + stage.stageHeight) / 3
                maxY() - minY()
                ));
    }

    private function maxY():Number {
        return minY() + topHeight /*+ 32*/ - stage.stageHeight + certificatePanel.height;
    }

    private function minY():Number {
        return stage.stageHeight - certificatePanel.height /*- 16*/;
    }

    private function certificateMouseUp(event:Event):void {
        certificatePanel.stopDrag();
    }

    private function createButtonsPanel():void {
        buttonsPanel = new Sprite;
        var load:SimpleButton = new ShellButton("Загрузить");
        var print:SimpleButton = new ShellButton("Напечатать");
        var image:SimpleButton = new ShellButton("Сохранить изображение", true);
        slider = new Slider(0, 1, 150);

        load.x = BUTTONS_LEFT;
        load.y = BUTTONS_TOP;
        print.x = load.x + load.width + BUTTONS_SKIP;
        print.y = BUTTONS_TOP;
        image.x = print.x + print.width + BUTTONS_SKIP;
        image.y = BUTTONS_TOP;
        slider.x = image.x + image.width + 2 * BUTTONS_SKIP;
        slider.y = BUTTONS_TOP;

        slider.addEventListener(Slider.VALUE_CHANGED, rescaleCertificate);

        load.addEventListener(MouseEvent.CLICK, loadClick);
        print.addEventListener(MouseEvent.CLICK, printClick);
        image.addEventListener(MouseEvent.CLICK, imageClick);

        buttonsPanel.addChild(load);
        buttonsPanel.addChild(print);
        buttonsPanel.addChild(image);
        buttonsPanel.addChild(slider);

        topHeight = 2 * BUTTONS_TOP + load.height;

        buttonsPanel.graphics.beginFill(certLightColor);
        buttonsPanel.graphics.drawRect(0, 0, 4000, topHeight);
        buttonsPanel.graphics.endFill();
    }

    private function imageClick(event:Event):void {
        var pngEncoder:PNGEncoder = new PNGEncoder();
        var bitmapData:BitmapData = new BitmapData(img.width, img.height);
        bitmapData.draw(certificatePanel);
        var byteArray:ByteArray = pngEncoder.encode(bitmapData);
        var file:FileReference = new FileReference();
        file.save(byteArray, "certificate.png");
    }

    private function loadClick(event:MouseEvent):void {
        if (DEBUG_MODE) {
            fileLoaded(null, DEBUG_MODE);
            return;
        }

        helloTextField.htmlText = WELCOME_MESSAGE + LOADING_MESSAGE;

        /*
         var _sdfasfd:TextField = new TextField;
         welcomePanel.addChild(_sdfasfd);
         _sdfasfd.text = 'ok';

         var smallLatency:Timer = new Timer(100, 1);
         smallLatency.addEventListener(TimerEvent.TIMER, function(event:Event):void {

         certificateFile = new FileReference();
         certificateFile.addEventListener(Event.SELECT, fileSelected);
         certificateFile.addEventListener(Event.CANCEL, fileSelectionCanceled);
         try {
         if (!certificateFile.browse([
         new FileFilter("Файлы сертификатов конкурса КИО", "*.kio-certificate"),
         new FileFilter("Все файлы", "*.*")
         ]))
         _sdfasfd.text = 'failed to browse';
         } catch(e:Error) {
         _sdfasfd.text = 'exc ' + e.message;
         }

         });

         smallLatency.start();

         var _sdfasfd:TextField = new TextField;
         welcomePanel.addChild(_sdfasfd);
         _sdfasfd.text = 'ok';*/

        certificateFile = new FileReference();
        certificateFile.addEventListener(Event.SELECT, fileSelected);
        certificateFile.addEventListener(Event.CANCEL, fileSelectionCanceled);
        certificateFile.browse([
            new FileFilter("Файлы сертификатов конкурса КИО", "*.kio-certificate"),
            new FileFilter("Все файлы", "*.*")
        ]);
    }

    private function fileSelectionCanceled(event:Event):void {
        helloTextField.htmlText = WELCOME_MESSAGE;
    }

    private function createWelcomePanel():void {
        welcomePanel = new Sprite;

        helloTextField = TextUtils.createCustomTextField();
        helloTextField.styleSheet = new StyleSheet();
        helloTextField.styleSheet.parseCSS(
                " p {font-family: KioAmbassadore; font-size: 26; color:#000000; text-align:justify;} " +
                        ".h1 { color:#000000; font-weight:bold;} " +
                        ".red {color:#ff2222}"
                );
        helloTextField.htmlText = WELCOME_MESSAGE;
        welcomePanel.addChild(helloTextField);

        welcomePanel.addEventListener(MouseEvent.CLICK, loadClick);
    }

    private function placeElement(event:Event = null):void {
        trace("resizing " + stage.stageWidth + 'x' + stage.stageHeight);
        if (welcomePanel)
            resizeWelcomePanel();
        resizeButtonsPanel();
        resizeCertificatePanel();
    }

    private function resizeWelcomePanel():void {
        welcomePanel.graphics.beginFill(certColor);
        welcomePanel.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
        welcomePanel.graphics.endFill();

        helloTextField.width = stage.stageWidth;
        helloTextField.x = 0;
        helloTextField.y = (stage.stageHeight - helloTextField.height) / 2;
    }

    private function resizeCertificatePanel():void {
        rescaleCertificate();
    }

    private function resizeButtonsPanel():void {
        buttonsPanel.x = 0;
        buttonsPanel.y = 0
    }

    private function fileSelected(event:Event):void {
        certificateFile.addEventListener(Event.COMPLETE, fileLoaded);
        certificateFile.load();
    }

    private function fileLoaded(event:Event, cert_data:String = null):void {
        var certificate:Object;
        if (cert_data)
            certificate = JSON.decode(JSON.decode(cert_data).json_certificate);
        else
            certificate = loadCertificate(certificateFile.data);


        if (welcomePanel) {
            removeChild(welcomePanel);
            welcomePanel = null;
            addChild(certificatePanel);
            addChild(buttonsPanel);
        }

        var img_asset:BitmapAsset;
        if (isTeacher(certificate))
            img_asset = isMale(certificate) ? IMG_TEACHER_M : IMG_TEACHER_F;
        else if (needDisplayRank(certificate))
            img_asset = isMale(certificate) ? IMG_RANK_M : IMG_RANK_F;
        else
            img_asset = isMale(certificate) ? IMG_NO_RANK_M : IMG_NO_RANK_F;

        img = img_asset.bitmapData;
        certificatePanel.graphics.clear();
        certificatePanel.graphics.beginBitmapFill(img);
        certificatePanel.graphics.drawRect(0, 0, img.width, img.height);
        certificatePanel.graphics.endFill();

        putDataOnCertificate(certificate);

        rescaleCertificate();
    }

    private function putDataOnCertificate(certificate:Object):void {
        while (certificatePanel.numChildren > 0)
            certificatePanel.removeChildAt(0);

        var fi:TextField = TextUtils.createTextFieldWithFont('KioAmbassadore', 125, false, true);
        fi.autoSize = TextFieldAutoSize.CENTER;
        fi.x = 0;
        fi.width = img.width;
        fi.y = isTeacher(certificate) ? 1400 : 1320;
        if (isTeacher(certificate))
            fi.text = certificate._anketa.surname + ' ' + certificate._anketa.name + ' ' + certificate._anketa.second_name;
        else
            fi.text = certificate._anketa.surname + ' ' + certificate._anketa.name;

        if (fi.width > img.width) {
            //125 - fi.width
            // ?  - img.width - 10
            var modifiedFormat:TextFormat = new TextFormat('KioAmbassadore', 125 * (img.width - 10) / fi.width);
            modifiedFormat.align = TextFormatAlign.CENTER;
            fi.setTextFormat(modifiedFormat);
        }

        certificatePanel.addChild(fi);

        if (needDisplayRank(certificate) && !isTeacher(certificate)) {
            var rank:TextField = TextUtils.createTextFieldWithFont('KioAmbassadore', 67, false, true);
            rank.autoSize = TextFieldAutoSize.NONE;
            var strange_left_padding:int = 20;
            rank.x = - strange_left_padding;
            rank.width = img.width + strange_left_padding;
            rank.y = 1870;
            rank.text = certificate._rank + ' место ( ' + (certificate._level == 1 ? 'I' : 'II') + ' уровень )';
            certificatePanel.addChild(rank);
        }

        if (!isTeacher(certificate)) {
            var y0:int = 2020;
            y0 += 24 + displayProblemInfo(y0, "Сады Семирамиды", [
                "Орошенных комнат: " + o(certificate, 'semiramida', 'rooms') + ' из 209',
                "Длина труб в этажах: " + o(certificate, 'semiramida', 'pipesLength')
            ]);

            if (certificate._level == 1) {
                y0 += 24 + displayProblemInfo(y0, "Глазастый робот", [
                    "Распознается цифр: " + o(certificate, 'digit', 'recognized') + " из 10",
                    "Элементов: " + o(certificate, 'digit', 'elements')
                ]);

                y0 += 24 + displayProblemInfo(y0, "Нить Ариадны", [
                    "Время: " + o(certificate, 'ariadne', 'time') + " с."
                ]);
            } else {
                y0 += 24 + displayProblemInfo(y0, "Почтовые индексы", [
                    "Распознается ситуаций: " + o(certificate, 'digit', 'recognized') + " из 100",
                    "Элементов: " + o(certificate, 'digit', 'elements')
                ]);

                y0 += 24 + displayProblemInfo(y0, "Характер физических законов", [
                    "Не в той половинке: " + o(certificate, 'physics', 'other_half'),
                    "Клеток с одним шаром: " + o(certificate, 'physics', 'one_ball'),
                    "Расстояние до центра: " + o(certificate, 'physics', 'center_distance')
                ]);
            }
        } else {
            //display position
            var pos:TextField = TextUtils.createTextFieldWithFont('KioArial', 50, true, true);
            pos.autoSize = TextFieldAutoSize.CENTER;
            pos.x = 0;
            pos.width = img.width;
            pos.y = 1510;
            pos.defaultTextFormat = new TextFormat('KioArial', 50, 0, true, true);
            pos.text = certificate._position;
            certificatePanel.addChild(pos);
        }

        //put signatures
        var delta_up:int;
        var delta_right:int;
        if (isTeacher(certificate)) {
            delta_up = 100;
            delta_right = 140;
        }
        else {
            delta_up = 0;
            delta_right = 0;
        }

        drawSignature(IMG_BASHMAKOV, 1270 - 150 + delta_right, 2470 - delta_up);
        drawSignature(IMG_POZDNKOV, 1175 - 150 + delta_right, 2660 - delta_up);
        drawSignature(IMG_ROMANOVSKY, 995 - 200 + delta_right, 2780 - delta_up);
        drawSignature(IMG_TEREKHOV, 1255 - 130 + delta_right, 3030 - delta_up);

        /*

         "Константинопольский Константин"
         - шрифт Ambassadore Type;
         - 30 пт,(высота надписи, включая заглавные буквы 6,54 мм);
         - обводка 0,2 мм;
         - выравнивание - по вертикальному центру сертификата;

         "5964 место ( I уровень )"
         - "I" - заглавная буква "И" английского алфавита;
         - после открывающей скобки - пробел, перед закрывающей скобкой -
         пробел (если не сделать, то в этом шрифте будут очень маленькие
         расстояния между символами);
         - шрифт Ambassadore Type (файлы прилагаю);
         - 16 пт, (высота надписи, включая скобки, 4,783 мм);
         - обводка 0,5 мм ;
         - выравнивание - по вертикальному центру сертификата.

         "результат в задаче “Лазерное шоу”"
         - Arial, 11 пт (высота надписи, включая заглавные буквы 3,621 мм);
         - Bold.


         Для учителей

         Настоящий сертификат удостоверяет, что ФИО, название
         населенного пункта, принимал(а) активное участие в организации
         и проведении Международного Конкурса по применению ИКТ
         в естественных науках и математике «Конструируй, Исследуй ,
         Оптимизируй» (КИО-2011)

         Для участников первой сотни

         Настоящий сертификат удостоверяет, что ФИ принимал(а)
         участие в Международном Конкурсе по применению ИКТ в
         естественных науках и математике «Конструируй, Исследуй,
         Оптимизируй» (КИО-2011) и занял (а) в рейтинге такое-то место
         Далее, как было.

         Для участников за первой сотни

         Настоящий сертификат удостоверяет, что ФИ, принимал(а)
         участие в Международном Конкурсе по применению ИКТ в
         естественных науках и математике «Конструируй, Исследуй,
         Оптимизируй» (КИО-2011)
         Далее подписи
         */
    }

    private function o(c:Object, f1:String, f2:String):* {
        if (!c[f1])
            return "-";
        else
            return c[f1][f2];
    }

    private function drawSignature(bmp:BitmapData, x0:int, y0:int):void {
        var g:Graphics = certificatePanel.graphics;

        var mm:Matrix = new Matrix();
        mm.scale(5 / 7, 5 / 7);
        mm.translate(x0, y0);
        g.beginBitmapFill(bmp, mm, false);
        g.drawRect(x0, y0, bmp.width, bmp.height);
        g.endFill();
    }

    private function displayProblemInfo(y0:int, name:String, info:Array):int {
        var nameTf:TextField = TextUtils.createTextFieldWithFont("KioArial", 46, false, false);
        nameTf.x = 365;
        nameTf.y = y0;
        nameTf.htmlText = "<b>Результат в задаче \u00AB" + name + "\u00BB</b>";
        certificatePanel.addChild(nameTf);

        var dataTf:TextField = TextUtils.createTextFieldWithFont("KioArial", 46, true, false);
        dataTf.x = 1650;
        dataTf.y = y0;
        dataTf.width = 100500;
        dataTf.htmlText = "<b>" + info.join("<br>") + "</b>";
        certificatePanel.addChild(dataTf);

        return dataTf.height;
    }

    private function loadCertificate(data:ByteArray):Object {
        var keyed_certificate:Object = JSON.decode(data.readUTFBytes(data.length));
        var json_certificate:String = keyed_certificate.json_certificate;
        if (KioChecker.signString(json_certificate) != keyed_certificate.signature)
            throw new IOError('Подпись не соответствует сертификату');
        return JSON.decode(json_certificate);
    }

    private function printClick(event:Event):void {
        var printJob:PrintJob = new PrintJob();
        if (printJob.start()) {
            var scaleF:Number = Math.min(printJob.pageWidth / img.width, printJob.pageHeight / img.height);
            certificatePanel.scaleX = scaleF;
            certificatePanel.scaleY = scaleF;

            var options:PrintJobOptions = new PrintJobOptions();
            options.printAsBitmap = true;
            try {
                printJob.addPage(certificatePanel, null, options);
                printJob.send();
            } catch(e:Error) {
                //do nothing
            } finally {
                certificatePanel.scaleX = 1;
                certificatePanel.scaleY = 1;
            }
        }
    }

    private function rescaleCertificate(event:Event = null):void {
        if (img == null)
            return;

        var spaceWidth:Number = stage.stageWidth;
        var spaceHeight:Number = stage.stageHeight - buttonsPanel.height;

        var certWidth:Number = img.width;
        var certHeight:Number = img.height;

        //get previous top line
        var topPercents:Number = (topHeight - certificatePanel.y) / certificatePanel.height;

        var scFrom:Number = spaceWidth / certWidth;
        var scTo:Number = spaceHeight / certHeight;

        if (scFrom > scTo) {
            var temp:Number = scFrom;
            scFrom = scTo;
            scTo = temp;
        }

        var scale:Number = scFrom + slider.value * (scTo - scFrom);

        var transformationMatrix:Matrix = new Matrix();
        transformationMatrix.scale(scale, scale);
        certificatePanel.transform.matrix = transformationMatrix;

        //move certificate
        certificatePanel.x = Math.round((stage.stageWidth - certWidth * scale) / 2);

        var newY:Number = topHeight - certHeight * scale * topPercents;
        if (newY < minY())
            newY = minY();
        if (newY > maxY())
            newY = maxY();

        certificatePanel.y = newY;
    }

    private function makeWhiteTransparent(bmp:BitmapData):void {
        bmp.threshold(
                bmp,
                new Rectangle(0, 0, bmp.width, bmp.height),
                new Point(0, 0),
                "==",
                0xFFFFFFFF
                );
    }

    private function isMale(certificate:Object):Boolean {
        var s_n:String = certificate._anketa.second_name;
        return s_n.toLowerCase().charAt(s_n.length - 1) == 'ч'; //русское ч
    }

    private function isTeacher(certificate:Object):Boolean {
        return certificate._is_teacher;
    }

    private static function needDisplayRank(certificate:Object):Boolean {
        return certificate._rank < 100;
    }

}
}
