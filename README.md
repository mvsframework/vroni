vroni
=====

Some wrapping code to make Martin Held's VRONI work in my code.

How to use this
===============

First off: VRONI, a program to compue Voronoi partitions (and all kinds of related things), written by Martin Held, *IS NOT IN THE PUBLIC DOMAIN*!

However, you can still use it for academic purposes as Prof. Held will most likely grant you an academic license if you contact him (see <code>src/README.md</code>)

With that out of the way, the only modification to the sources I did was to wrap everything into a VRONI C++-namespace.
With that done (and copying the modified--and renamed to <code>*.cpp</code>--files to the <code>/src</code> directory), the provided CMake files should provide a linkable VRONI library.

