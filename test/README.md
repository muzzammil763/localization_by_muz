# Test Suite for localization_by_muz

This directory contains comprehensive tests for the localization_by_muz Flutter package.

## Test Files

### `localization_by_muz_test.dart` - Main Test Suite
- **String Extension Tests**: Tests for the `.localize()` extension method
- **LocalizationManager Tests**: Core functionality tests for the singleton manager
- **LocalizationProvider Widget Tests**: Flutter widget testing for the provider
- **Integration Tests**: End-to-end testing of complete localization flows
- **Edge Cases and Error Handling**: Tests for unusual scenarios and error conditions

### `json_localization_test.dart` - JSON-Based Localization Tests
- **JSON Loading Tests**: Tests for loading and parsing localization.json files
- **JSON Localization with String Extension**: Integration between JSON data and extension methods
- **Complex JSON Scenarios**: Tests for large files, unicode characters, and edge cases

### `performance_test.dart` - Performance and Efficiency Tests
- **Rapid Locale Changes**: Tests performance under frequent language switching
- **Large Translation Sets**: Tests with thousands of translations
- **Multiple Listeners**: Tests listener performance with many subscribers
- **UI Update Performance**: Tests widget update efficiency during locale changes
- **Memory Usage**: Tests for memory leaks and resource management

### `edge_cases_test.dart` - Edge Cases and Error Handling
- **String Edge Cases**: Empty strings, special characters, very long strings
- **Locale Edge Cases**: Invalid locale codes, case sensitivity, special characters
- **Translation Map Edge Cases**: Null values, duplicate keys, extremely large maps
- **Widget Edge Cases**: Multiple providers, disposal during changes
- **Concurrent Access**: Thread safety and concurrent operations
- **Memory and Resource Management**: Resource cleanup and leak prevention

### `simple_test.dart` - Basic Functionality Verification
- Simple tests for core functionality verification
- Quick smoke tests for basic package operations

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/simple_test.dart
flutter test test/localization_by_muz_test.dart
flutter test test/json_localization_test.dart
flutter test test/performance_test.dart
flutter test test/edge_cases_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

## Test Coverage Areas

### Core Functionality
- ✅ String extension method `.localize()`
- ✅ Inline translations with Maps
- ✅ JSON-based translations
- ✅ LocalizationManager singleton
- ✅ Locale switching and state management
- ✅ Listener pattern for UI updates

### Widget Integration
- ✅ LocalizationProvider widget
- ✅ Context-based locale changes
- ✅ Widget tree integration
- ✅ State management and rebuilds

### Performance
- ✅ Rapid locale changes
- ✅ Large translation datasets
- ✅ Multiple listeners
- ✅ UI update efficiency
- ✅ Memory usage optimization

### Error Handling
- ✅ Missing translation files
- ✅ Malformed JSON data
- ✅ Invalid locale codes
- ✅ Null and empty values
- ✅ Concurrent access scenarios

### Edge Cases
- ✅ Unicode and special characters
- ✅ Very long strings
- ✅ Empty translation maps
- ✅ Nested widget providers
- ✅ Resource cleanup and disposal

## Test Philosophy

These tests follow Flutter and Dart best practices:

1. **Unit Tests**: Test individual functions and methods in isolation
2. **Widget Tests**: Test Flutter widgets and their interactions
3. **Integration Tests**: Test complete user workflows
4. **Performance Tests**: Verify efficiency under load
5. **Edge Case Tests**: Handle unusual and error conditions

## Mocking Strategy

- Uses Flutter's built-in test mocking for asset loading
- Mocks JSON file loading for isolated testing
- Tests both success and failure scenarios
- Verifies graceful error handling

## Assertions and Expectations

- Tests use descriptive assertions
- Performance tests include timing expectations
- Memory tests verify resource cleanup
- UI tests check for proper widget updates

## Continuous Integration

These tests are designed to run in CI/CD environments:
- No external dependencies required
- Fast execution times
- Deterministic results
- Clear failure messages