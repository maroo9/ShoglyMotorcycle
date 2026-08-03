import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'SHOGHLY'**
  String get app_name;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @re_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get re_password;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get create_account;

  /// No description provided for @already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already Have an Account?'**
  String get already_have_account;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Have an Account?'**
  String get dont_have_account;

  /// No description provided for @forget_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forget_password;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password;

  /// No description provided for @login_with_google.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get login_with_google;

  /// No description provided for @welcome_message.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcome_message;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @motorcycles.
  ///
  /// In en, this message translates to:
  /// **'Motorcycles'**
  String get motorcycles;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @total_motorcycles.
  ///
  /// In en, this message translates to:
  /// **'Total Motorcycles'**
  String get total_motorcycles;

  /// No description provided for @available_motorcycles.
  ///
  /// In en, this message translates to:
  /// **'Available Motorcycles'**
  String get available_motorcycles;

  /// No description provided for @rented_motorcycles.
  ///
  /// In en, this message translates to:
  /// **'Rented Motorcycles'**
  String get rented_motorcycles;

  /// No description provided for @under_maintenance.
  ///
  /// In en, this message translates to:
  /// **'Under Maintenance'**
  String get under_maintenance;

  /// No description provided for @total_revenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get total_revenue;

  /// No description provided for @pending_payments.
  ///
  /// In en, this message translates to:
  /// **'Pending Payments'**
  String get pending_payments;

  /// No description provided for @add_motorcycle.
  ///
  /// In en, this message translates to:
  /// **'Add Motorcycle'**
  String get add_motorcycle;

  /// No description provided for @edit_motorcycle.
  ///
  /// In en, this message translates to:
  /// **'Edit Motorcycle'**
  String get edit_motorcycle;

  /// No description provided for @delete_motorcycle.
  ///
  /// In en, this message translates to:
  /// **'Delete Motorcycle'**
  String get delete_motorcycle;

  /// No description provided for @motorcycle_details.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle Details'**
  String get motorcycle_details;

  /// No description provided for @motorcycle_name.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle Name'**
  String get motorcycle_name;

  /// No description provided for @motorcycle_model.
  ///
  /// In en, this message translates to:
  /// **'Characteristics / Model'**
  String get motorcycle_model;

  /// No description provided for @license_number.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get license_number;

  /// No description provided for @owner_name.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get owner_name;

  /// No description provided for @motorcycle_image.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle Image'**
  String get motorcycle_image;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @rented.
  ///
  /// In en, this message translates to:
  /// **'Rented'**
  String get rented;

  /// No description provided for @maintenance_status.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance_status;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @customer_name.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customer_name;

  /// No description provided for @customers_list.
  ///
  /// In en, this message translates to:
  /// **'Customers List'**
  String get customers_list;

  /// No description provided for @add_customer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get add_customer;

  /// No description provided for @edit_customer.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get edit_customer;

  /// No description provided for @customer_details.
  ///
  /// In en, this message translates to:
  /// **'Customer Details'**
  String get customer_details;

  /// No description provided for @national_id.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get national_id;

  /// No description provided for @driving_license.
  ///
  /// In en, this message translates to:
  /// **'Driving License Number'**
  String get driving_license;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @rental.
  ///
  /// In en, this message translates to:
  /// **'Rental'**
  String get rental;

  /// No description provided for @rent_motorcycle.
  ///
  /// In en, this message translates to:
  /// **'Rent Motorcycle'**
  String get rent_motorcycle;

  /// No description provided for @rental_history.
  ///
  /// In en, this message translates to:
  /// **'Rental History'**
  String get rental_history;

  /// No description provided for @rental_start.
  ///
  /// In en, this message translates to:
  /// **'Rental Start'**
  String get rental_start;

  /// No description provided for @rental_end.
  ///
  /// In en, this message translates to:
  /// **'Rental End'**
  String get rental_end;

  /// No description provided for @rental_period.
  ///
  /// In en, this message translates to:
  /// **'Rental Period'**
  String get rental_period;

  /// No description provided for @daily_rate.
  ///
  /// In en, this message translates to:
  /// **'Daily Rate'**
  String get daily_rate;

  /// No description provided for @total_amount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get total_amount;

  /// No description provided for @payments_title.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments_title;

  /// No description provided for @record_payment.
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get record_payment;

  /// No description provided for @payment_amount.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount'**
  String get payment_amount;

  /// No description provided for @amount_paid.
  ///
  /// In en, this message translates to:
  /// **'Amount Paid'**
  String get amount_paid;

  /// No description provided for @remaining_balance.
  ///
  /// In en, this message translates to:
  /// **'Remaining Balance'**
  String get remaining_balance;

  /// No description provided for @payment_date.
  ///
  /// In en, this message translates to:
  /// **'Payment Date'**
  String get payment_date;

  /// No description provided for @payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get payment_method;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @bank_transfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get bank_transfer;

  /// No description provided for @financial_inflows.
  ///
  /// In en, this message translates to:
  /// **'Financial Inflows'**
  String get financial_inflows;

  /// No description provided for @maintenance_title.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance_title;

  /// No description provided for @add_maintenance.
  ///
  /// In en, this message translates to:
  /// **'Add Maintenance'**
  String get add_maintenance;

  /// No description provided for @edit_maintenance.
  ///
  /// In en, this message translates to:
  /// **'Edit Maintenance'**
  String get edit_maintenance;

  /// No description provided for @maintenance_type.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Type'**
  String get maintenance_type;

  /// No description provided for @maintenance_cost.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Cost'**
  String get maintenance_cost;

  /// No description provided for @maintenance_date.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Date'**
  String get maintenance_date;

  /// No description provided for @technician.
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get technician;

  /// No description provided for @service_details.
  ///
  /// In en, this message translates to:
  /// **'Service Details'**
  String get service_details;

  /// No description provided for @next_service.
  ///
  /// In en, this message translates to:
  /// **'Next Service'**
  String get next_service;

  /// No description provided for @mark_completed.
  ///
  /// In en, this message translates to:
  /// **'Mark Completed'**
  String get mark_completed;

  /// No description provided for @oil_change.
  ///
  /// In en, this message translates to:
  /// **'Oil Change'**
  String get oil_change;

  /// No description provided for @engine_repair.
  ///
  /// In en, this message translates to:
  /// **'Engine Repair'**
  String get engine_repair;

  /// No description provided for @brake_service.
  ///
  /// In en, this message translates to:
  /// **'Brake Service'**
  String get brake_service;

  /// No description provided for @tire_replacement.
  ///
  /// In en, this message translates to:
  /// **'Tire Replacement'**
  String get tire_replacement;

  /// No description provided for @general_service.
  ///
  /// In en, this message translates to:
  /// **'General Service'**
  String get general_service;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @no_motorcycles.
  ///
  /// In en, this message translates to:
  /// **'No motorcycles available.'**
  String get no_motorcycles;

  /// No description provided for @no_customers.
  ///
  /// In en, this message translates to:
  /// **'No customers found.'**
  String get no_customers;

  /// No description provided for @no_payments.
  ///
  /// In en, this message translates to:
  /// **'No payment records found.'**
  String get no_payments;

  /// No description provided for @no_maintenance.
  ///
  /// In en, this message translates to:
  /// **'No maintenance records found.'**
  String get no_maintenance;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @data_saved.
  ///
  /// In en, this message translates to:
  /// **'Data saved successfully.'**
  String get data_saved;

  /// No description provided for @data_updated.
  ///
  /// In en, this message translates to:
  /// **'Data updated successfully.'**
  String get data_updated;

  /// No description provided for @data_deleted.
  ///
  /// In en, this message translates to:
  /// **'Data deleted successfully.'**
  String get data_deleted;

  /// No description provided for @search_motorcycle.
  ///
  /// In en, this message translates to:
  /// **'Search Motorcycle'**
  String get search_motorcycle;

  /// No description provided for @search_customer.
  ///
  /// In en, this message translates to:
  /// **'Search Customer'**
  String get search_customer;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @renter.
  ///
  /// In en, this message translates to:
  /// **'Current Renter'**
  String get renter;

  /// No description provided for @quick_actions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quick_actions;

  /// No description provided for @recent_activity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recent_activity;

  /// No description provided for @representative.
  ///
  /// In en, this message translates to:
  /// **'Representative'**
  String get representative;

  /// No description provided for @representatives.
  ///
  /// In en, this message translates to:
  /// **'Representatives'**
  String get representatives;

  /// No description provided for @add_representative.
  ///
  /// In en, this message translates to:
  /// **'Add Representative'**
  String get add_representative;

  /// No description provided for @edit_representative.
  ///
  /// In en, this message translates to:
  /// **'Edit Representative'**
  String get edit_representative;

  /// No description provided for @representative_details.
  ///
  /// In en, this message translates to:
  /// **'Representative Details'**
  String get representative_details;

  /// No description provided for @representative_name.
  ///
  /// In en, this message translates to:
  /// **'Representative Name'**
  String get representative_name;

  /// No description provided for @assign_motorcycle.
  ///
  /// In en, this message translates to:
  /// **'Assign Motorcycle'**
  String get assign_motorcycle;

  /// No description provided for @assigned_motorcycle.
  ///
  /// In en, this message translates to:
  /// **'Assigned Motorcycle'**
  String get assigned_motorcycle;

  /// No description provided for @search_motorcycle_hint.
  ///
  /// In en, this message translates to:
  /// **'Search by ID, license, owner, color, or model'**
  String get search_motorcycle_hint;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @save_motorcycle.
  ///
  /// In en, this message translates to:
  /// **'Save Motorcycle'**
  String get save_motorcycle;

  /// No description provided for @add_motorcycle_first.
  ///
  /// In en, this message translates to:
  /// **'Add a motorcycle first before adding a representative.'**
  String get add_motorcycle_first;

  /// No description provided for @motorcycle_id_code.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle ID / Code'**
  String get motorcycle_id_code;

  /// No description provided for @could_not_load_representatives.
  ///
  /// In en, this message translates to:
  /// **'Could not load representatives'**
  String get could_not_load_representatives;

  /// No description provided for @no_representatives_found.
  ///
  /// In en, this message translates to:
  /// **'No representatives found'**
  String get no_representatives_found;

  /// No description provided for @could_not_load_motorcycles.
  ///
  /// In en, this message translates to:
  /// **'Could not load motorcycles'**
  String get could_not_load_motorcycles;

  /// No description provided for @representative_start_date.
  ///
  /// In en, this message translates to:
  /// **'Representative Start Date'**
  String get representative_start_date;

  /// No description provided for @motorcycle_number.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle Number'**
  String get motorcycle_number;

  /// No description provided for @owner_phone.
  ///
  /// In en, this message translates to:
  /// **'Owner Phone'**
  String get owner_phone;

  /// No description provided for @representative_phone.
  ///
  /// In en, this message translates to:
  /// **'Representative Phone'**
  String get representative_phone;

  /// No description provided for @total_collected_today.
  ///
  /// In en, this message translates to:
  /// **'Total Collected Today'**
  String get total_collected_today;

  /// No description provided for @reset_day.
  ///
  /// In en, this message translates to:
  /// **'Reset Day'**
  String get reset_day;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
