/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 05.02.11
 * Time: 22:08
 */
package ru.ipo.kio.api {
import flash.events.Event;
import flash.events.NetStatusEvent;
import flash.net.SharedObject;
import flash.net.SharedObjectFlushStatus;
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

    private static const LSO_SIZE:int = 1000000;

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

    public function flush():void {
        if (_local == null) {
            createLSO();
            if (_local == null) {
                KioBase.instance.complainLSO();
                return;
            }
            //copy data
            for (var key:String in _data)
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

        if (!ud[id]) {
            ud[id] = {};
        }

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
            _data.users = [{}];
            user_index = 0;
        }

        if (one_problem_debug_regime) {
            if (! _data.one_problem_debug_user)
                _data.one_problem_debug_user = {};
            return _data.one_problem_debug_user;
        }

        return _data.users[user_index];
    }

    public function set userData(data:Object):void {
        var ud:Object = userData;

        var key:String;

        for (key in ud)
            delete ud[key];

        for (key in data)
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

    public function getUserInfo(ind:int, showInstitution:Boolean):String {
        var anketa:Object = _data.users[ind].kio_base.anketa;
        var result:String = anketa.surname + ' ' + anketa.name + ' ' + anketa.second_name;
        if (showInstitution)
            result += ' ' + anketa.inst_name + ' ' + anketa.grade;
        return  result;
    }

    public function createNewParticipant():void {
        _data.users.push({});
        userIndex = _data.users.length - 1;
    }

    public function setOneProblemDebugRegime():void {
        one_problem_debug_regime = true;
    }
}
}
