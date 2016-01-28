package ru.ipo.kio._16.rockgarden.model {
internal class PointDescription {
    public var pos:Number;
    public var is_new:Boolean;
    public var start_of:Segment;

    public function PointDescription(pos:Number, is_new:Boolean, start_of:Segment) {
        this.pos = pos;
        this.is_new = is_new;
        this.start_of = start_of;
    }
}
}
