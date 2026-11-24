enum DatasetKind { classic, release22 }

extension DatasetKindLabel on DatasetKind {
  String get edition {
    return switch (this) {
      DatasetKind.classic => 'ADr',
      DatasetKind.release22 => 'НП',
    };
  }
}
