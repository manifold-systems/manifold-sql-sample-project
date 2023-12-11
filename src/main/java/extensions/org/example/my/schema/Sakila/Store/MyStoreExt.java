package extensions.org.example.my.schema.Sakila.Store;

import manifold.ext.rt.api.Extension;
import manifold.ext.rt.api.This;
import org.example.my.schema.Sakila;

/** Sample extension method on {@code Store} */
@Extension
public class MyStoreExt {
    public static String hello(@This Sakila.Store thiz) {
        return thiz.display();
    }
}
