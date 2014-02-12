/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 05.02.11
 * Time: 22:08
 */
package ru.ipo.kio.api {
import flash.crypto.generateRandomBytes;
import flash.events.Event;
import flash.events.NetStatusEvent;
import flash.net.SharedObject;
import flash.net.SharedObjectFlushStatus;
import flash.system.Capabilities;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

import ru.ipo.kio.base.KioBase;

/*
data
|
|----problem_id_1
|----problem_id_2
|----problem_id_3
|----kio_base
     |
     |---anketa
 */

public class LsoProxy {

    private static var _instance:Dictionary = new Dictionary(); // year + '-' + level -> LsoProxy

    private static const LSO_SIZE:int = 2000000;

    private var level:int;
    private var year:int;

    public static function getInstance(level:int, year:int):LsoProxy {
        var id:String = year + '-' + level;
        if (!_instance[id])
            _instance[id] = new LsoProxy(level, year);
        return _instance[id];
    }

    private var _local:SharedObject;
    private var _data:Object;

    public function LsoProxy(level:int, year:int) {
        this.level = level;
        this.year = year;
        _data = {};
        createLSO();
        normalize_users();
    }

    //remove all users with anketa not filled, create users if they don't exist
    private function normalize_users():void {
        if (!_data.users)
            _data.users = [];

        var remove_indexes:Array = [];
        for (var i:int = 0; i < _data.users.length; i++)
            if (!_data.users[i].kio_base || !_data.users[i].kio_base.anketa_filled)
                remove_indexes.push(i);

        for (i = remove_indexes.length - 1; i >= 0; i--)
            _data.users.splice(remove_indexes[i], 1);
    }

    private function createLSO():void {
        try {
            _local = getLocal();
            _data = _local.data;
        } catch (e:Error) {
            _local = null;
        }
    }

    private function getLocal():SharedObject {
        var local:SharedObject = SharedObject.getLocal("ru/ipo/kio/" + year + "/" + level, "/");
        local.addEventListener(NetStatusEvent.NET_STATUS, function (event:Event):void {
            trace('net status handled');
            //TODO find out WHY this event was not triggered before. (google suggests it is just not triggered at all in linux)
        });
        return local;
    }

    public function get usedBytes():uint {
        return _local.size; //TODO local might not be initialized
    }

    public function flush():void {
        if (_local == null) {
            createLSO();
            if (_local == null) {
                KioBase.instance.complainLSO();
                return;
            }
            //copy data
            for (var key:String in _data)
                if (_data.hasOwnProperty(key))
                    _local.data[key] = _data[key];
            _data = _local.data;
        }

        try {
            if (_local.flush(LSO_SIZE) != SharedObjectFlushStatus.FLUSHED)
                KioBase.instance.complainLSO();
        } catch (e:Error) {
            KioBase.instance.complainLSO();
        }
    }

    public function getProblemData(id:String):Object {
        var ud:Object = userData;

        if (ud == null) //TODO this is a dirty hack
            return {};

        if (!ud[id])
            ud[id] = {};

        return ud[id];
    }

    public function getGlobalData():Object {
        var ud:Object = userData;

        if (!ud.kio_base)
            ud.kio_base = {};

        return ud.kio_base;
    }

    public function getAnketa():Object {
        var gd:Object = getGlobalData();
        if (!gd.anketa)
            gd.anketa = {};

        return gd.anketa;
    }

    public function get userData():Object {
        if (!_data.users  || _data.users.length == 0) {
            _data.users = [createNewUserObject()];
            user_index = 0;
        }

        if (one_problem_debug_regime) {
            if (! _data.one_problem_debug_user)
                _data.one_problem_debug_user = {};
            return _data.one_problem_debug_user;
        }

        return _data.users[user_index];
    }

    private static function createNewUserObject():Object {
        var rnd:ByteArray = generateRandomBytes(1);
        var randomPart:String = DataUtils.convertByteArrayToString(rnd);

        //generate time part
        var now:Date = new Date();
        var timePart:String = now.getTime().toString(16);

        return {
            user_id: timePart + "-" + randomPart
        }
    }

    public function set userData(data:Object):void {
        var ud:Object = userData;

        var key:String;

        for (key in ud)
            if (ud.hasOwnProperty(key))
                delete ud[key];

        for (key in data)
            if (data.hasOwnProperty(key))
                ud[key] = data[key];
        flush();
    }

    public function hasAnketa():Boolean {
        return getGlobalData().anketa;
    }

    /*//used to be used for debugging
    public function cleanup():void {
        for (var key:String in _data)
            _data[key] = null;
        flush();
    }*/

    //-------------------------------------------------------
    // Multiple users
    //-------------------------------------------------------

    private var user_index:int = -1;
    private var one_problem_debug_regime:Boolean = false;

    public function userCount():int {
        normalize_users();

        return _data.users.length;
    }

    public function get userIndex():int {
        return user_index;
    }

    public function set userIndex(value:int):void {
        user_index = value;
    }

    public function getUserInfo(ind:int, showInstitution:Boolean, shorten_names:Boolean = false):String {
        var anketa:Object = _data.users[ind].kio_base.anketa;
        
        var name:String = anketa.name;
        var s_name:String = anketa.second_name;
        
        if (shorten_names) {
            name = name.charAt().toUpperCase() + '.';
            s_name = s_name.charAt().toUpperCase() + '.';
        }

        var result:String = anketa.surname + ' ' + name + ' ' + s_name;
        if (showInstitution)
            result += ' ' + anketa.inst_name + ' ' + anketa.grade;
        return  result;
    }

    public function createNewParticipant():void {
        _data.users.push(createNewUserObject());
        userIndex = _data.users.length - 1;
    }

    public function setOneProblemDebugRegime():void {
        one_problem_debug_regime = true;
    }

    public function isOneProblemDebugRegime():Boolean {
        return one_problem_debug_regime;
    }

    // machine id

    public function get machineId():String {
        if (!("machine_id" in _data))
            _data.machine_id = generateMachineId();
        return _data.machine_id;
    }

    public static function get machineInfo():Object {
        return {
            os: Capabilities.os,
            manufacturer: Capabilities.manufacturer,
            cpu: Capabilities.cpuArchitecture,
            version: Capabilities.version,
            language: Capabilities.language,
            playerType: Capabilities.playerType,
            dpi: Capabilities.screenDPI,
            screenWidth: Capabilities.screenResolutionX,
            screenHeight: Capabilities.screenResolutionY
        }
    }

    private static function generateMachineId():String {
        //generate random part
        var rnd_len:int = 3;
        var rnd:ByteArray = generateRandomBytes(rnd_len);
        var randomPart:String = DataUtils.convertByteArrayToString(rnd);

        //generate machine-id part
        var info:Object = machineInfo;
        var infoString:String = "";
        for each (var key:String in ["os", "manufacturer", "cpu", "version", "language", "playerType", "dpi", "screenWidth", "screenHeight"])
            infoString += info[key] + "|";

        var machineInfoPart:String = DataUtils.hash(infoString).toString(16);

        //generate time part
        var now:Date = new Date();
        var timePart:String = now.getTime().toString(16);

        return machineInfoPart + "-" + timePart + "-" + randomPart;
    }
}
}
