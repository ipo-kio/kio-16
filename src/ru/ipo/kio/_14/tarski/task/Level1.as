/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.task {

import ru.ipo.kio._14.tarski.model.Configuration;
import ru.ipo.kio._14.tarski.model.Figure;
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.ShapeValue;
import ru.ipo.kio._14.tarski.model.properties.SizeValue;
import ru.ipo.kio._14.tarski.model.properties.ValueHolder;

public class Level1 {

    private var rightConfiguration:Vector.<Configuration> = new Vector.<Configuration>();

    private var wrongConfiguration:Vector.<Configuration> = new Vector.<Configuration>();

    public function Level1() {

        var configuration:Configuration = new Configuration(5, 5);
        configuration.figures.push(new Figure(0,0,ColorValue.BLUE,SizeValue.BIG,ShapeValue.CUBE));


        rightConfiguration.push(configuration);

        registerAvailableValues();
    }

    private function registerAvailableValues():void {
        ValueHolder.registerColor(new ColorValue(ColorValue.RED, "Красный", 0xFF0000));
        ValueHolder.registerColor(new ColorValue(ColorValue.BLUE, "Синий", 0x0000FF));
        ValueHolder.registerShape(new ShapeValue(ShapeValue.SPHERE, "Шар"));
        ValueHolder.registerShape(new ShapeValue(ShapeValue.CUBE, "Куб"));
        ValueHolder.registerSize(new SizeValue(SizeValue.SMALL, "Малый"));
        ValueHolder.registerSize(new SizeValue(SizeValue.BIG, "Большой"));
    }
}
}
