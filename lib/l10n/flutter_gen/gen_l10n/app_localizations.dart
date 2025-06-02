import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @perfil.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get perfil;

  /// No description provided for @ajustes.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get ajustes;

  /// No description provided for @crearLibro.
  ///
  /// In en, this message translates to:
  /// **'Create Book'**
  String get crearLibro;

  /// No description provided for @inicio.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get inicio;

  /// No description provided for @buscar.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get buscar;

  /// No description provided for @h_btn_iniciarSesion.
  ///
  /// In en, this message translates to:
  /// **'Login button'**
  String get h_btn_iniciarSesion;

  /// No description provided for @lb_btn_iniciarSesion.
  ///
  /// In en, this message translates to:
  /// **'Press to log in'**
  String get lb_btn_iniciarSesion;

  /// No description provided for @txt_btn_iniciarSesion.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get txt_btn_iniciarSesion;

  /// No description provided for @h_btn_crearCuenta.
  ///
  /// In en, this message translates to:
  /// **'Create account button'**
  String get h_btn_crearCuenta;

  /// No description provided for @lb_btn_crearCuenta.
  ///
  /// In en, this message translates to:
  /// **'Press to create new account'**
  String get lb_btn_crearCuenta;

  /// No description provided for @txt_btn_crearCuenta.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get txt_btn_crearCuenta;

  /// No description provided for @lb_nombreUsuario.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get lb_nombreUsuario;

  /// No description provided for @h_nombreUsuario.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get h_nombreUsuario;

  /// No description provided for @lb_pass.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get lb_pass;

  /// No description provided for @h_pass.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get h_pass;

  /// No description provided for @error_pass.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get error_pass;

  /// No description provided for @error_username.
  ///
  /// In en, this message translates to:
  /// **'Username not found'**
  String get error_username;

  /// No description provided for @lb_nombre.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get lb_nombre;

  /// No description provided for @h_nombre.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get h_nombre;

  /// No description provided for @lb_apellidos.
  ///
  /// In en, this message translates to:
  /// **'Enter your surname'**
  String get lb_apellidos;

  /// No description provided for @h_apellidos.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get h_apellidos;

  /// No description provided for @error_name.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get error_name;

  /// No description provided for @error_surname.
  ///
  /// In en, this message translates to:
  /// **'Surname cannot be empty'**
  String get error_surname;

  /// No description provided for @lb_email.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get lb_email;

  /// No description provided for @h_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get h_email;

  /// No description provided for @error_email.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get error_email;

  /// No description provided for @error_email_taken.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get error_email_taken;

  /// No description provided for @error_username_taken.
  ///
  /// In en, this message translates to:
  /// **'This username is already in use'**
  String get error_username_taken;

  /// No description provided for @txt_btn_enviar.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get txt_btn_enviar;

  /// No description provided for @error_buscarLibros.
  ///
  /// In en, this message translates to:
  /// **'No books found'**
  String get error_buscarLibros;

  /// No description provided for @mensajeAgregado.
  ///
  /// In en, this message translates to:
  /// **'Booke saved correctly'**
  String get mensajeAgregado;

  /// No description provided for @comentario.
  ///
  /// In en, this message translates to:
  /// **'Coment'**
  String get comentario;

  /// No description provided for @nota.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get nota;

  /// No description provided for @anadir.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get anadir;

  /// No description provided for @errorCampoVacio.
  ///
  /// In en, this message translates to:
  /// **'Please fill in the fields'**
  String get errorCampoVacio;

  /// No description provided for @descripcion.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descripcion;

  /// No description provided for @genero.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get genero;

  /// No description provided for @fechaPublicacion.
  ///
  /// In en, this message translates to:
  /// **'Release date'**
  String get fechaPublicacion;

  /// No description provided for @lb_darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get lb_darkTheme;

  /// No description provided for @lb_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get lb_language;

  /// No description provided for @lb_textSize.
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get lb_textSize;

  /// No description provided for @cambiarPass.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get cambiarPass;

  /// No description provided for @passActual.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get passActual;

  /// No description provided for @nuevaPass.
  ///
  /// In en, this message translates to:
  /// **'New passsword'**
  String get nuevaPass;

  /// No description provided for @confirmarPass.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmarPass;

  /// No description provided for @errorPassDistintas.
  ///
  /// In en, this message translates to:
  /// **'Password don\'t match'**
  String get errorPassDistintas;

  /// No description provided for @borrarCuenta.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get borrarCuenta;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @confirmacionLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure do you want logout?'**
  String get confirmacionLogout;

  /// No description provided for @cancelar.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelar;

  /// No description provided for @confirmacionBorrarCuenta.
  ///
  /// In en, this message translates to:
  /// **'Are you sure do you want to delete account?'**
  String get confirmacionBorrarCuenta;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
