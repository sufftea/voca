/// Generated file. Do not edit.
///
/// Locales: 1
/// Strings: 18
///
/// Built on 2023-02-04 at 15:00 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, _StringsEn> {
	en(languageCode: 'en', build: _StringsEn.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, _StringsEn> build;

	/// Gets current instance managed by [LocaleSettings].
	_StringsEn get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
_StringsEn get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class Translations {
	Translations._(); // no constructor

	static _StringsEn of(BuildContext context) => InheritedLocaleData.of<AppLocale, _StringsEn>(context).translations;
}

/// The provider for method B
class TranslationProvider extends BaseTranslationProvider<AppLocale, _StringsEn> {
	TranslationProvider({required super.child}) : super(
		initLocale: LocaleSettings.instance.currentLocale,
		initTranslations: LocaleSettings.instance.currentTranslations,
	);

	static InheritedLocaleData<AppLocale, _StringsEn> of(BuildContext context) => InheritedLocaleData.of<AppLocale, _StringsEn>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	_StringsEn get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, _StringsEn> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale) => instance.setLocale(locale);
	static AppLocale setLocaleRaw(String rawLocale) => instance.setLocaleRaw(rawLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, _StringsEn> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class _StringsEn implements BaseTranslations<AppLocale, _StringsEn> {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsEn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, _StringsEn> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final _StringsEn _root = this; // ignore: unused_field

	// Translations
	late final _StringsHomeEn home = _StringsHomeEn._(_root);
	late final _StringsNavBarEn navBar = _StringsNavBarEn._(_root);
	late final _StringsSearchEn search = _StringsSearchEn._(_root);
	late final _StringsRangeSelectionEn rangeSelection = _StringsRangeSelectionEn._(_root);
}

// Path: home
class _StringsHomeEn {
	_StringsHomeEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String languageIs({required Object language}) => 'Language: ${language}';
	late final _StringsHomeDiscoverBannerEn discoverBanner = _StringsHomeDiscoverBannerEn._(_root);
	late final _StringsHomePracticeBannerEn practiceBanner = _StringsHomePracticeBannerEn._(_root);
}

// Path: navBar
class _StringsNavBarEn {
	_StringsNavBarEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get home => 'Home';
	String get settings => 'Settings';
}

// Path: search
class _StringsSearchEn {
	_StringsSearchEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get lookUpWord => 'Look up a word';
}

// Path: rangeSelection
class _StringsRangeSelectionEn {
	_StringsRangeSelectionEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get learning => 'Learning';
	String get known => 'Known';
	String get selectedRange => 'Selected range:';
	String knownAmount({required Object n}) => 'known: ${n}';
	String learningAmount({required Object n}) => 'learning: ${n}';
}

// Path: home.discoverBanner
class _StringsHomeDiscoverBannerEn {
	_StringsHomeDiscoverBannerEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get header => 'Discover words you don\'t know yet';
	String nofWordsToUncover({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		zero: 'No words to uncover in this range',
		one: '1 word to uncover in this range',
		many: '${n} words to uncover in this range',
		other: '${n} words to uncover in this range',
	);
	String get discoverNew => 'Discover new';
}

// Path: home.practiceBanner
class _StringsHomePracticeBannerEn {
	_StringsHomePracticeBannerEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get header => 'Practice with spaced repetition';
	String todaysGoal({required Object n}) => 'Today\'s goal: ${n}';
	String get practice => 'Practice';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on _StringsEn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'home.languageIs': return ({required Object language}) => 'Language: ${language}';
			case 'home.discoverBanner.header': return 'Discover words you don\'t know yet';
			case 'home.discoverBanner.nofWordsToUncover': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
				zero: 'No words to uncover in this range',
				one: '1 word to uncover in this range',
				many: '${n} words to uncover in this range',
				other: '${n} words to uncover in this range',
			);
			case 'home.discoverBanner.discoverNew': return 'Discover new';
			case 'home.practiceBanner.header': return 'Practice with spaced repetition';
			case 'home.practiceBanner.todaysGoal': return ({required Object n}) => 'Today\'s goal: ${n}';
			case 'home.practiceBanner.practice': return 'Practice';
			case 'navBar.home': return 'Home';
			case 'navBar.settings': return 'Settings';
			case 'search.lookUpWord': return 'Look up a word';
			case 'rangeSelection.learning': return 'Learning';
			case 'rangeSelection.known': return 'Known';
			case 'rangeSelection.selectedRange': return 'Selected range:';
			case 'rangeSelection.knownAmount': return ({required Object n}) => 'known: ${n}';
			case 'rangeSelection.learningAmount': return ({required Object n}) => 'learning: ${n}';
			default: return null;
		}
	}
}
