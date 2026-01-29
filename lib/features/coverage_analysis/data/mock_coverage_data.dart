class MockCoverageData {
  final double currentCoverage;
  final double targetCoverage;
  final String status;
  final double healthTarget;
  final double healthCurrent;
  final double termTarget;
  final double termCurrent;

  const MockCoverageData({
    required this.currentCoverage,
    required this.targetCoverage,
    required this.status,
    required this.healthTarget,
    required this.healthCurrent,
    required this.termTarget,
    required this.termCurrent,
  });
}

const mockCoverageData = MockCoverageData(
  currentCoverage: 5000300,
  targetCoverage: 11000000,
  status: 'Underinsured',
  healthTarget: 1000000,
  healthCurrent: 300,
  termTarget: 10000000,
  termCurrent: 5000000,
);
