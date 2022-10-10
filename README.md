# Flutter widgets library
- [Flutter widgets library](#flutter-widgets-library)
  - [Getting started](#getting-started)
  - [Loaders](#loaders)
    - [`SpringLoader`](#springloader)
    - [`CircleLoader`](#circleloader)
    - [`DotsLoader`](#dotsloader)
  - [Buttons](#buttons)
    - [`FadeButton`](#fadebutton)
  - [Layouts](#layouts)
    - [`SeparatedChildBuilderDelegate`](#separatedchildbuilderdelegate)
      - [Example:](#example)
  - [Widgets](#widgets)
    - [AsyncCallbackBuilder](#asynccallbackbuilder)
    - [Delayed](#delayed)
    - [IsScrolled](#isscrolled)

***

## Getting started

To add a widget to your app:

1. Add this to your `pubspec.yaml` file.

    ```yaml
    dependencies:
      widgets_library:
        git: git@github.com:HTD-Health/flutter_widgets_library.git
    ```
2. You are ready! 😉

***

## Loaders
### `SpringLoader`

![example](./readme/spring_loader.gif)  

### `CircleLoader`

![example](./readme/circle_loader.gif)  

### `DotsLoader`

![example](./readme/dots_loader.gif)  

## Buttons

### `FadeButton`
A widget that provides a fade effect when a tap gesture is performed on its child.  

![example](./readme/fade_button.gif)  

## Layouts

### `SeparatedChildBuilderDelegate`
This delegate can be used together with `SliverList` to provide a solution similar to `ListView.separated`.

#### Example:
```dart
class SeparatedChildBuilderDelegateExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = ['item 1', 'item 2', 'item 3'];

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SeparatedChildBuilderDelegate(
            childCount: items.length,
            itemBuilder: (BuildContext context, int index) => Text(items[index]),
            separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 24),
          )
        )
      ],
    );
  }
}
```

## Widgets

### AsyncCallbackBuilder
A widget that encapsulates asynchronously running procedures with automatic state updates.

### Delayed
Widget that displays its' child after the given [duration].
```dart
Widget build(BuildContext context) {
  /// The progress indicator widget will be displayed
  /// after a delay of 2 seconds
  return Delayed(
    duration: Duration(seconds: 2),
    child: CircularProgressIndicator(),
  );
}

```

### IsScrolled
A simple utility widget that provides information on whether the scrollable is already scrolled or has more space to scroll.

Example usage:
```dart
Widget build(BuildContext context) {
  return IsScrolled(
    builder: (context, controller, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text('The list is scrolled: ${state.isScrolled}'),
        ),
        body: ListView.builder(
          controller: controller,
          itemBuilder: (context, index) => /* *** */,
        ),
      );
    },
  );
}
```