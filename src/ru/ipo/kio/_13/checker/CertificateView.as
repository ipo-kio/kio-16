/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 22.04.11
 * Time: 17:07
 */
package ru.ipo.kio._13.checker {

import com.adobe.serialization.json.JSON_k;

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.errors.IOError;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.printing.PrintJob;
import flash.printing.PrintJobOptions;
import flash.text.StyleSheet;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextLineMetrics;
import flash.utils.ByteArray;

import mx.core.BitmapAsset;
import mx.graphics.codec.PNGEncoder;

import ru.ipo.kio._13.blocks.BlocksProblem;
import ru.ipo.kio._13.clock.ClockProblem;

import ru.ipo.kio._13.cut.CutProblem;

import ru.ipo.kio.api.TextUtils;
import ru.ipo.kio.base.displays.ShellButton;

public class CertificateView extends Sprite {

    private const WELCOME_MESSAGE:String = "<p class='h1' align='center'>Нажмите на любое место экрана, чтобы загрузить сертификат</p>";
    private const LOADING_MESSAGE:String = "<p align='center' class='red'>Загрузка...</p>";

    [Embed(source="resources/Sertificat_001b.png")]
    private static var CERT_IMAGE:Class;
    private var IMG_CERT:BitmapAsset = new CERT_IMAGE;

    [Embed(source="resources/Sertificat_Teacher.png")]
    private static var CERT_IMAGE_TEACHER:Class;
    private const IMG_CERT_TEACHER:BitmapAsset = new CERT_IMAGE_TEACHER;

    /*    [Embed(source="resources/Sertificat_008female.png")]
    private static var CERT_IMAGE_TEACHER_FEMALE:Class;
    private const IMG_CERT_TEACHER_FEMALE:BitmapAsset = new CERT_IMAGE_TEACHER_FEMALE;*/

    [Embed(systemFont="Arial", fontName="KioArial", embedAsCFF = "false", mimeType="application/x-font")]
    private static var ARIAL_NORMAL_FONT:Class;

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

    private static const AMBASSADORE_HEIGHT_OVER_ACCENT:Number = 76.55 / 57.75;
    private static const AMBASSADORE_K_FIX:Number = 61 / 50;
    private static const AMBASSADORE_m_FIX:Number = AMBASSADORE_K_FIX * 32 / 24;

    private static var TEST_CERT_F_N:String = '{"signature":653277,"json_certificate":"{\\"TRAIN\\":{\\"happyPassengers\\":38,\\"hasCrash\\":false,\\"time\\":29},\\"_scores\\":1106,\\"_level\\":0,\\"TRAIN_scores\\":362,\\"stagelights\\":{\\"firstMax\\":99,\\"second\\":[255,216,255,225,222,231],\\"secondMax\\":99,\\"_scores_2\\":263,\\"visible\\":true,\\"first\\":[173,238,229,181,246,249],\\"_scores_1\\":225,\\"bandages\\":10},\\"id\\":{\\"length\\":21},\\"_anketa\\":{\\"inst_name\\":\\"МКОУ Хоперская SOSH urjupinskagomunicipalnogo rajona Волгоградской области\\",\\"email\\":\\"kulakowair@yandex.ru\\",\\"grade\\":\\"1\\",\\"address\\":\\"403105, Волгоградская область\\\\rУрюпинский район, \\\\rх. Криушинский,\\\\rул. Гагарина, дом 3\\",\\"name\\":\\"Александра\\",\\"surname\\":\\"Константинопольская\\",\\"second_name\\":\\"ВЛАДИМИРОВНА\\"},\\"_rank\\":352,\\"stagelights_scores\\":488,\\"id_scores\\":256,\\"_login\\":\\"vlg-0002-003-1@kio-0\\"}"}';
//    private static var TEST_CERT_M_N:String = '{"json_certificate":"{\\"_level\\":2,\\"semiramida\\":{\\"pipesLength\\":216,\\"rooms\\":209},\\"digit\\":{\\"elements\\":1,\\"recognized\\":8},\\"digit_scores\\":25,\\"physics_scores\\":277,\\"_rank\\":108,\\"_anketa\\":{\\"second_name\\":\\"НИКОЛАЕВИЧ\\",\\"grade\\":\\"21\\",\\"name\\":\\"КРИСТИН\\",\\"email\\":\\"It-mggtk@mail.ru\\",\\"surname\\":\\"БЕРЕЗНИКОВ\\",\\"inst_name\\":\\"МГГТК АГУ\\",\\"address\\":\\"р. Адыгея, г.Майкоп, ул. 2-ая Ветеранов 1\\"},\\"_login\\":\\"bereznikova421\\",\\"semiramida_scores\\":60,\\"physics\\":{\\"other_half\\":\\"0\\",\\"center_distance\\":\\"29.01\\",\\"one_ball\\":\\"3\\"},\\"_scores\\":362}","signature":717561}';
//    private static var TEST_CERT_F_R:String = '{"json_certificate":"{\\"_level\\":2,\\"semiramida\\":{\\"pipesLength\\":216,\\"rooms\\":209},\\"digit\\":{\\"elements\\":1,\\"recognized\\":8},\\"digit_scores\\":25,\\"physics_scores\\":277,\\"_rank\\":58,\\"_anketa\\":{\\"second_name\\":\\"НИКОЛАЕВНА\\",\\"grade\\":\\"21\\",\\"name\\":\\"КРИСТИНА\\",\\"email\\":\\"It-mggtk@mail.ru\\",\\"surname\\":\\"БЕРЕЗНИКОВА\\",\\"inst_name\\":\\"МГГТК АГУ\\",\\"address\\":\\"р. Адыгея, г.Майкоп, ул. 2-ая Ветеранов 1\\"},\\"_login\\":\\"bereznikova421\\",\\"semiramida_scores\\":60,\\"physics\\":{\\"other_half\\":\\"0\\",\\"center_distance\\":\\"29.01\\",\\"one_ball\\":\\"3\\"},\\"_scores\\":362}","signature":717561}';
//    private static var TEST_CERT_M_R:String = '{"json_certificate":"{\\"_level\\":2,\\"semiramida\\":{\\"pipesLength\\":216,\\"rooms\\":209},\\"digit\\":{\\"elements\\":1,\\"recognized\\":8},\\"digit_scores\\":25,\\"physics_scores\\":277,\\"_rank\\":68,\\"_anketa\\":{\\"second_name\\":\\"НИКОЛАЕВИЧ\\",\\"grade\\":\\"21\\",\\"name\\":\\"КРИСТИН\\",\\"email\\":\\"It-mggtk@mail.ru\\",\\"surname\\":\\"БЕРЕЗНИКОВ\\",\\"inst_name\\":\\"МГГТК АГУ\\",\\"address\\":\\"р. Адыгея, г.Майкоп, ул. 2-ая Ветеранов 1\\"},\\"_login\\":\\"bereznikova421\\",\\"semiramida_scores\\":60,\\"physics\\":{\\"other_half\\":\\"0\\",\\"center_distance\\":\\"29.01\\",\\"one_ball\\":\\"3\\"},\\"_scores\\":362}","signature":717561}';
    private static var TEST_CERT_T_F:String = '{"json_certificate":"{\\"_level\\":2,\\"_position\\":\\"Очень серьезный организатор\\\\nВ очень серьезной организации\\",\\"_is_teacher\\":true,\\"semiramida\\":{\\"pipesLength\\":216,\\"rooms\\":209},\\"digit\\":{\\"elements\\":1,\\"recognized\\":8},\\"digit_scores\\":25,\\"physics_scores\\":277,\\"_rank\\":68,\\"_anketa\\":{\\"second_name\\":\\"НИКОЛАЕВНА\\",\\"grade\\":\\"21\\",\\"name\\":\\"КРИСТИНА\\",\\"email\\":\\"It-mggtk@mail.ru\\",\\"surname\\":\\"БЕРЕЗНИКОВА\\",\\"inst_name\\":\\"МГГТК АГУ\\",\\"address\\":\\"р. Адыгея, г.Майкоп, ул. 2-ая Ветеранов 1\\"},\\"_login\\":\\"bereznikova421\\",\\"semiramida_scores\\":60,\\"physics\\":{\\"other_half\\":\\"0\\",\\"center_distance\\":\\"29.01\\",\\"one_ball\\":\\"3\\"},\\"_scores\\":362}","signature":717561}';
//    private static var TEST_CERT_T_M:String = '{"json_certificate":"{\\"_level\\":2,\\"_position\\":\\"Очень серьезный организатор\\\\nВ очень серьезной организации\\",\\"_is_teacher\\":true,\\"semiramida\\":{\\"pipesLength\\":216,\\"rooms\\":209},\\"digit\\":{\\"elements\\":1,\\"recognized\\":8},\\"digit_scores\\":25,\\"physics_scores\\":277,\\"_rank\\":68,\\"_anketa\\":{\\"second_name\\":\\"НИКОЛАЕВИЧ\\",\\"grade\\":\\"21\\",\\"name\\":\\"КРИСТИН\\",\\"email\\":\\"It-mggtk@mail.ru\\",\\"surname\\":\\"БЕРЕЗНИКОВ\\",\\"inst_name\\":\\"МГГТК АГУ\\",\\"address\\":\\"р. Адыгея, г.Майкоп, ул. 2-ая Ветеранов 1\\"},\\"_login\\":\\"bereznikova421\\",\\"semiramida_scores\\":60,\\"physics\\":{\\"other_half\\":\\"0\\",\\"center_distance\\":\\"29.01\\",\\"one_ball\\":\\"3\\"},\\"_scores\\":362}","signature":717561}';
//    private static var TEST_CERT_LNG:String = '{"json_certificate":"{\\"_level\\":2,\\"_position\\":\\"Очень серьезный организатор\\\\nВ очень серьезной организации\\",\\"_is_teacher\\":true,\\"semiramida\\":{\\"pipesLength\\":216,\\"rooms\\":209},\\"digit\\":{\\"elements\\":1,\\"recognized\\":8},\\"digit_scores\\":25,\\"physics_scores\\":277,\\"_rank\\":68,\\"_anketa\\":{\\"second_name\\":\\"НИКОЛАЕВИЧЕВИЧ\\",\\"grade\\":\\"21\\",\\"name\\":\\"КРИСТИНИАН\\",\\"email\\":\\"It-mggtk@mail.ru\\",\\"surname\\":\\"БЕРЕЗНИКОВАШВИЛИЦЫКСОН\\",\\"inst_name\\":\\"МГГТК АГУ\\",\\"address\\":\\"р. Адыгея, г.Майкоп, ул. 2-ая Ветеранов 1\\"},\\"_login\\":\\"bereznikova421\\",\\"semiramida_scores\\":60,\\"physics\\":{\\"other_half\\":\\"0\\",\\"center_distance\\":\\"29.01\\",\\"one_ball\\":\\"3\\"},\\"_scores\\":362}","signature":717561}';

    private static const DEBUG_MODE:String = null;//TEST_CERT_T_F;

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
    private static const LEVEL_ALL:Array = [1872, 1430, 1310]; //TODO how many

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
            trace('loading debug cert:');
            trace(DEBUG_MODE);
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
            certificate = JSON_k.decode(JSON_k.decode(cert_data).json_certificate);
        else
            certificate = loadCertificate(certificateFile.data);


        if (welcomePanel) {
            removeChild(welcomePanel);
            welcomePanel = null;
            addChild(certificatePanel);
            addChild(buttonsPanel);
        }

        var img_asset:BitmapAsset;
        //TODO select here teachers bg
        if (isTeacher(certificate))
            img_asset = IMG_CERT_TEACHER;
        else
            img_asset = IMG_CERT;

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

        var name_size:int = 61 * AMBASSADORE_K_FIX;
        var fi:TextField = TextUtils.createTextFieldWithFont('KioAmbassadore', name_size * AMBASSADORE_HEIGHT_OVER_ACCENT, false, true);
        fi.autoSize = TextFieldAutoSize.CENTER;
        fi.x = 0;
        fi.width = img.width;
        fi.y = isTeacher(certificate) ? 1590 : 1405 - name_size;
        if (isTeacher(certificate))
            fi.text = certificate._anketa.surname + ' ' + certificate._anketa.name + ' ' + certificate._anketa.second_name;
        else
            fi.text = (certificate._anketa.surname + ' ' + certificate._anketa.name).toUpperCase();

        if (fi.width > img.width) {
            //125 - fi.width
            // ?  - img.width - 10
            var modifiedFormat:TextFormat = new TextFormat('KioAmbassadore', name_size * AMBASSADORE_HEIGHT_OVER_ACCENT * (img.width - 10) / fi.width);
            modifiedFormat.align = TextFormatAlign.CENTER;
            fi.setTextFormat(modifiedFormat);
        }

        certificatePanel.addChild(fi);

        if (certificate._level == 0)
            var level_name:String = 'начальный уровень';
        else if (certificate._level == 1)
            level_name = ' I уровень ';
        else if (certificate._level == 2)
            level_name = ' II уровень ';

        var info_size:int = 32 * AMBASSADORE_m_FIX;

        if (!isTeacher(certificate)) {

            fi = TextUtils.createTextFieldWithFont('KioAmbassadore', info_size * AMBASSADORE_HEIGHT_OVER_ACCENT, false, true);
            fi.autoSize = TextFieldAutoSize.CENTER;
            fi.x = 0;
            fi.width = img.width;
            fi.y = 1589 - info_size;
            fi.text = isMale(certificate) ?
                    'принимал участие в Международном конкурсе' :
                    'принимала участие в Международном конкурсе';
            certificatePanel.addChild(fi);

            fi = TextUtils.createTextFieldWithFont('KioAmbassadore', info_size * AMBASSADORE_HEIGHT_OVER_ACCENT, false, true);
            fi.autoSize = TextFieldAutoSize.CENTER;
            fi.x = 0;
            fi.width = img.width;
            fi.y = 1672 - info_size;
            fi.text = 'по применению ИКТ в естественных науках, технологиях';
            certificatePanel.addChild(fi);

            fi = TextUtils.createTextFieldWithFont('KioAmbassadore', info_size * AMBASSADORE_HEIGHT_OVER_ACCENT, false, true);
            fi.autoSize = TextFieldAutoSize.CENTER;
            fi.x = 0;
            fi.width = img.width;
            fi.y = 1761 - info_size;
            fi.text = 'и математике «Конструируй! Исследуй! Оптимизируй!» (КИО-2013)';
            certificatePanel.addChild(fi);

            fi = TextUtils.createTextFieldWithFont('KioAmbassadore', info_size * AMBASSADORE_HEIGHT_OVER_ACCENT, false, true);
            fi.autoSize = TextFieldAutoSize.CENTER;
            fi.x = 0;
            fi.width = img.width;
            fi.y = 1845 - info_size;
            fi.text = isMale(certificate) ?
                    'и занял в рейтинге (' + level_name + ')' :
                    'и заняла в рейтинге (' + level_name + ')';
            certificatePanel.addChild(fi);

            fi = TextUtils.createTextFieldWithFont('KioAmbassadore', info_size * AMBASSADORE_HEIGHT_OVER_ACCENT, false, true);
            fi.autoSize = TextFieldAutoSize.CENTER;
            fi.x = 0;
            fi.width = img.width;
            fi.y = 1925 - info_size;
            fi.text = certificate._rank + ' место из ' + LEVEL_ALL[certificate._level];
            certificatePanel.addChild(fi);

            var lm:TextLineMetrics = fi.getLineMetrics(0);
            trace('lm');
            trace(lm.ascent);
            trace(lm.descent);
            trace(lm.height);
            trace(lm.leading);
            trace(lm.width);
            trace(lm.x);
        }

        if (!isTeacher(certificate)) {

            //cuts problem

            var cutsTitle:String;
            switch (certificate._level) {
                case 0: cutsTitle = 'Разрезание'; break;
                case 1: cutsTitle = 'Меньше отходов!'; break;
                case 2: cutsTitle = 'Оптимальный раскрой'; break;
            }

            displayProblemInfo(2021, cutsTitle, [
                "Многоугольников: " + o(certificate, CutProblem.ID, 'polys'),
                "Площадь: " + o(certificate, CutProblem.ID, 'pieces'),
                "Обрезков: " + o(certificate, CutProblem.ID, 'offcuts')
            ], certificate[CutProblem.ID + '_scores']);

            //blocks problem

            var blocksTitle:String;
            switch  (certificate._level) {
                case 0: blocksTitle = 'Кран'; break;
                case 1: blocksTitle = 'Кран-автомат'; break;
                case 2: blocksTitle = 'Погрузка контейнеров'; break;
            }

            displayProblemInfo(2187, blocksTitle, [
                "Блоков на месте: " + o(certificate, BlocksProblem.ID, 'in_place'),
                certificate._level == 0 ?
                "Штрафных баллов: " + o(certificate, BlocksProblem.ID, 'penalty') :
                "Длина программы: " + o(certificate, BlocksProblem.ID, 'prg_len'),
                "Шагов программы: " + o(certificate, BlocksProblem.ID, 'steps')
            ], certificate[BlocksProblem.ID + '_scores']);

            //clock problem

            var clockTitle:String;
            switch  (certificate._level) {
                case 0: clockTitle = 'Часы'; break;
                case 1: clockTitle = 'Часы-ежедневник'; break;
                case 2: clockTitle = 'Часы-календарь'; break;
            }

            var err:String = '-';
            var size:String = '-';

            if (ClockProblem.ID in certificate && certificate[ClockProblem.ID] && 'absTransmissionError' in certificate[ClockProblem.ID]) {
                var errN:Number = certificate[ClockProblem.ID].absTransmissionError;

                if (certificate._level == 1)
                    errN /= 1000;
                if (certificate._level == 0)
                    errN /= 10;

                err = errN.toFixed(3) + '%';
                if (certificate[ClockProblem.ID].finished) {
                    if (certificate._level == 0)
                        size = Math.floor(certificate[ClockProblem.ID].square / 10000) + 'x' +
                                Math.floor(certificate[ClockProblem.ID].square / 100) % 100 + 'x' +
                                Math.floor(certificate[ClockProblem.ID].square % 100);
                    else
                        size = certificate[ClockProblem.ID].square.toFixed(3);
                }
            }

            displayProblemInfo(2353, clockTitle, [
                "Погрешность: " + err,
                "Размер корпуса: " + size
            ], certificate[ClockProblem.ID + '_scores']);

        } else {
            //display position
            var pos:TextField = TextUtils.createTextFieldWithFont('KioArial', 50, true, true);
            pos.autoSize = TextFieldAutoSize.CENTER;
            pos.x = 0;
            pos.width = img.width;
            pos.y = 1630;
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
        } else {
            delta_up = 0;
            delta_right = 100;

            drawSignature(IMG_BASHMAKOV, 60 + 1270 - 150 + delta_right, 2470 - delta_up);
            drawSignature(IMG_POZDNKOV, 60 + 1175 - 150 + delta_right, 2660 - delta_up);
            drawSignature(IMG_ROMANOVSKY, 60 + 995 - 200 + delta_right, 2780 - delta_up);
            drawSignature(IMG_TEREKHOV, 1255 - 130 + delta_right, 3030 - delta_up);
        }

        fi = TextUtils.createTextFieldWithFont('KioAmbassadore', info_size, false, true);
        fi.autoSize = TextFieldAutoSize.CENTER;
        fi.x = 0;
        fi.width = img.width;
        fi.y = 3420;
        fi.text = "№ сертификата: " + certificate2num(certificate);
        certificatePanel.addChild(fi);

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

    private static function truncate_long_num(num:Number):String {
        if (!num)
            return '';
        var n:String = num + '';
        if (n.length > 8)
            n = n.substr(0, 8);
        return n;
    }

    private static function o(c:Object, f1:String, f2:String):* {
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
        g.beginBitmapFill(bmp, mm, false, true);
        g.drawRect(x0, y0, bmp.width * 5 / 7, +bmp.height * 5 / 7);
        g.endFill();
    }

    private function displayProblemInfo(y0:int, name:String, info:Array, rank:int):void {
        var f_size:int = 24 * AMBASSADORE_m_FIX;
        var fi:TextField = TextUtils.createTextFieldWithFont('KioArial', f_size * AMBASSADORE_HEIGHT_OVER_ACCENT, false, true);
        fi.autoSize = TextFieldAutoSize.LEFT;
        fi.x = 231;
        fi.width = img.width;
        fi.y = y0 - f_size;
        fi.text = "Результат в задаче \u00AB" + name + "\u00BB";
        certificatePanel.addChild(fi);

        var dataTf:TextField = TextUtils.createTextFieldWithFont("KioArial", f_size * AMBASSADORE_HEIGHT_OVER_ACCENT, true, false);
        dataTf.autoSize = TextFieldAutoSize.LEFT;
        dataTf.width = img.width;
        dataTf.x = 1673;
        dataTf.y = y0 - f_size;
        var txt:String = ''; //rank + ' место';
//        if (br_before_bracket)
//            txt += '<br>(';
//        else
//            txt += ' (';
        txt += info.join("<br>");
//        txt += ')';

        if (!rank)
            dataTf.htmlText = '-';
        else
            dataTf.htmlText = txt;
        certificatePanel.addChild(dataTf);
    }

    private static function getRankForProblem(level:int, scores:int):int {
        return LEVEL_ALL[level] - scores;
    }

    private static function loadCertificate(data:ByteArray):Object {
//        var keyed_certificate:Object = JSON_k.decode(data.readUTFBytes(data.length));
        var keyed_certificate:Object = JSON_k.decode(data.readMultiByte(data.length, 'x-cp1251'));
        var json_certificate:String = keyed_certificate.json_certificate;
        if (KioChecker.signString(json_certificate) != keyed_certificate.signature)
            throw new IOError('Подпись не соответствует сертификату');
        return JSON_k.decode(json_certificate);
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

    private static function makeWhiteTransparent(bmp:BitmapData):void {
        bmp.threshold(
                bmp,
                new Rectangle(0, 0, bmp.width, bmp.height),
                new Point(0, 0),
                "==",
                0xFFFFFFFF
                );
    }

    private static function isMale(certificate:Object):Boolean {
        var s_n:String = certificate._anketa.second_name;
        return s_n.toLowerCase().charAt(s_n.length - 1) == 'ч'; //русское ч
    }

    private static function isTeacher(certificate:Object):Boolean {
        return certificate._is_teacher;
    }

    private static function needDisplayRank(certificate:Object):Boolean {
        return certificate._rank < 100;
    }

    private static function certificate2num(certificate:Object):String {
        var name:String = certificate._anketa.name + certificate._anketa.surname;

        name = name.toUpperCase();

        var d:Number = 0;
        for (var i:int = 0; i < name.length; i++) {
            d *= 33;
            d += name.charCodeAt(i) - 'А'.charCodeAt(0);
        }

        var num:String = d.toString(36).toUpperCase();
        num = num.replace(/O/g, 'x');
        while (num.length % 4 != 0)
            num = '0' + num;

        var res:String = '';
        for (i = 0; i < num.length / 4; i++) {
            if (res.length != 0)
                res += '-';
            res += num.substr(4 * i, 4);
        }

        return res;
    }

}
}
