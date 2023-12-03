# ``GeoJSON``

This is a Swift package for working with GeoJSON data. 

## Overview

[GeoJSON](https://geojson.org) is a format for encoding a variety of geographic data structures. 

The implementation of this package aims to follow the specification defined in [RFC 7946](https://tools.ietf.org/html/rfc7946).
It contains necessary types conforming to `Codable` for easy de-/encoding of data.

## Topics

### Geometry Types

- ``Geometry``
- ``GeometryCollection``
- ``LineString``
- ``MultiLineString``
- ``Point``
- ``MultiPoint``
- ``Polygon``
- ``MultiPolygon``
- ``Position``
