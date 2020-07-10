/// A heterogeneous composition of other `Geometry` objects. For example, a `Geometry` object in the shape of a lowercase roman "i" can be composed of one
/// `Point` and one `LineString`.
/// See [RFC7946 Section 3.1.8](https://tools.ietf.org/html/rfc7946#section-3.1.8) for more information.
public typealias GeometryCollection = [Geometry]
