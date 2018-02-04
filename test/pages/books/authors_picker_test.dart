import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readathon/models/models.dart';
import 'package:readathon/pages/books/authors_picker.dart';

void main() {
  testWidgets(
      'AuthorsPicker should render only button if no authors are awailable',
      (WidgetTester tester) async {
    var givenAuthors = [].toSet();
    await tester.pumpWidget(_authorsPicker(givenAuthors));

    expect(find.byType(FlatButton), findsOneWidget);
    expect(find.byType(DropdownButton), findsNothing);
  });

  testWidgets(
      'AuthorsPicker should render dropdown without remove button if no author is picked',
      (WidgetTester tester) async {
    var givenAuthors = [new Author('Name')].toSet();
    await tester.pumpWidget(_authorsPicker(givenAuthors));

    expect(find.byType(DropdownButton), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.byType(FlatButton), findsOneWidget);
  });

  testWidgets('AuthorsPicker should render remove button for filled dropdowns',
      (WidgetTester tester) async {
    var givenAuthors = [
      new Author('Name1'),
      new Author('Name2'),
    ].toSet();
    await tester.pumpWidget(_authorsPicker(givenAuthors));

    //open dropdown and select first option
    await tester.tap(find.byType(DropdownButton).first);
    await tester.pump();
    await tester.tap(find.text('Name1').first);
    await tester.pump();

    expect(find.byType(DropdownButton), findsNWidgets(2));
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byType(FlatButton), findsOneWidget);
  });

  testWidgets('AuthorsPicker should remove picked author on button tap',
      (WidgetTester tester) async {
    var givenAuthors = [
      new Author('Name1'),
      new Author('Name2'),
    ].toSet();
    await tester.pumpWidget(_authorsPicker(givenAuthors));

    //open dropdown and select first option
    await tester.tap(find.byType(DropdownButton).first);
    await tester.pump();
    await tester.tap(find.text('Name1').first);
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    expect(find.byType(DropdownButton), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.byType(FlatButton), findsOneWidget);
  });
}

Widget _authorsPicker(Set givenAuthors) => new MaterialApp(
      home: new Material(
        child: new AuthorsPicker(givenAuthors),
      ),
    );
