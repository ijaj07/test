enum CoverageStatus {
  underinsured,
  overinsured,
  adequatelyInsured;

  static CoverageStatus fromValues(double current, double target) {
    if (current < target) {
      return CoverageStatus.underinsured;
    } else if (current > target * 1.1) {
      // Considering overinsured if > 10% more than target, or just strictly greater
      return CoverageStatus.overinsured;
    } else {
      return CoverageStatus.adequatelyInsured;
    }
  }
}
