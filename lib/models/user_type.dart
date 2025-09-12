enum UserType {
  carrier,
  driver,
  shipper;

  String toDisplayString() => switch (this) {
    UserType.carrier => "Carrier",
    UserType.driver => "Driver",
    UserType.shipper => "Shipper",
  };

  static UserType fromString(String value) => switch (value.toLowerCase()) {
    "carrier" => UserType.carrier,
    "driver" => UserType.driver,
    "shipper" => UserType.shipper,
    _ => throw ArgumentError("Invalid user type: $value"),
  };
}
