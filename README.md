###### Documentation languages

| [pt_BR](README-pt_BR.md) | en_US - this file |
|-------|-------|

Official CLI for the GetX™ framework.

```dart
// To install:
pub global activate vui_cli
// (to use this add the following to system PATH: [FlutterSDKInstallDir]\bin\cache\dart-sdk\bin

flutter pub global activate vui_cli

// To create a flutter project in the current directory:
// Note: By default it will take the folder's name as project name
// You can name the project with `vui create project:my_project`
// If the name has spaces use `vui create project:"my cool project"`
vui create project

// To generate the chosen structure on an existing project:
vui init

// To create a page:
// (Pages have controller, view, and binding)
// Note: you can use any name, ex: `vui create page:login`
vui create page:home

// To create a new controller in a specific folder:
// Note: you don't need to reference the folder,
// Getx will search automatically for the home folder
// and add your controller there.
vui create controller:dialogcontroller on home

// To create a new view in a specific folder:
// Note: you don't need to reference the folder,
// Getx will automatically search for the home folder
// and insert your view there.
vui create view:dialogview on home

// To create a new provider in a specific folder:
vui create provider:user on home

// To generate a localization file:
// Note: 'assets/locales' directory with your translation files in json format
vui generate locales assets/locales

// To generate a class model:
// Note: 'assets/models/user.json' path of your template file in json format
// Note: on  == folder output file
// Getx will automatically search for the home folder
// and insert your view there.
vui generate model on home with assets/models/user.json

//to generate the model without the provider
vui generate model on home with assets/models/user.json --skipProvider

//Note: the URL must return a json format
vui generate model on home from "https://api.github.com/users/CpdnCristiano"

// To install a package in your project (dependencies):
vui install camera

// To install several packages from your project:
vui install http path camera

// To install a package with specific version:
vui install path:1.6.4

// You can also specify several packages with version numbers

// To install a dev package in your project (dependencies_dev):
vui install flutter_launcher_icons --dev

// To remove a package from your project:
vui remove http

// To remove several packages from your project:
vui remove http path

// To update CLI:
vui update
// or `vui upgrade`

// Shows the current CLI version:
vui -v
// or `vui -version`

// For help
vui help
```

# Exploring the CLI

let's explore the existing commands in the cli

### Create project

```shell
  vui create project
```

Using to generate a new project, you can choose between [Flutter](https://github.com/flutter/flutter) and [get_server](https://pub.dev/packages/get_server), after creating the default directory, it will run a `get init` next command

### Init

```shell
  vui init
```

Use this command with care it will overwrite all files in the lib folder.
It allows you to choose between two structures, [getx_pattern](https://kauemurakami.github.io/getx_pattern/) and [clean](https://github.com/Katekko/ekko_app).

### Create page

```shell
  vui create page:name
```

this command allows you to create modules, it is recommended for users who chose to use getx_pattern.

creates the view, controller and binding files, in addition to automatically adding the route.

You can create a module within another module.

```shell
  vui create page:name on other_module
```

When creating a new project now and use `on` to create a page the CLI will use [children pages](https://github.com/jonataslaw/getx/blob/master/CHANGELOG.md#3210---big-update).

### Create Screen

```shell
  vui create screen:name
```

similar to the `create page`, but suitable for those who use Clean

### Create controller

```shell
  vui create controller:dialog on your_folder
```

create a controller in a specific folder.

_Using with option_
You can now create a template file, the way you prefer.

_run_

```shell
  vui create controller:auth with examples/authcontroller.dart on your_folder
```

or with url
_run_

```shell
  vui create controller:auth with 'https://raw.githubusercontent.com/jonataslaw/get_cli/master/samples_file/controller.dart.example' on your_folder
```

input:

```dart
@import

class @controller extends GetxController {
  final  email = ''.obs;
  final  password = ''.obs;
  void login() {
  }

}
```

output:

```dart
import 'package:get/get.dart';

class AuthController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  void login() {}
}
```

### Create view

```shell
  vui create view:dialog on your_folder
```

create a view in a specific folder

### Generate Locates

create the json language files in the assets/locales folder.

input:

pt_BR.json

```json
{
  "buttons": {
    "login": "Entrar",
    "sign_in": "Cadastrar-se",
    "logout": "Sair",
    "sign_in_fb": "Entrar com o Facebook",
    "sign_in_google": "Entar com o Google",
    "sign_in_apple": "Entar com a  Apple"
  }
}
```

en_US.json

```json
{
  "buttons": {
    "login": "Login",
    "sign_in": "Sign-in",
    "logout": "Logout",
    "sign_in_fb": "Sign-in with Facebook",
    "sign_in_google": "Sign-in with Google",
    "sign_in_apple": "Sign-in with Apple"
  }
}
```

Run :

```dart
vui generate locales assets/locales
```

output:

```dart
abstract class AppTranslation {

  static Map<String, Map<String, String>> translations = {
    'en_US' : Locales.en_US,
    'pt_BR' : Locales.pt_BR,
  };

}
abstract class LocaleKeys {
  static const buttons_login = 'buttons_login';
  static const buttons_sign_in = 'buttons_sign_in';
  static const buttons_logout = 'buttons_logout';
  static const buttons_sign_in_fb = 'buttons_sign_in_fb';
  static const buttons_sign_in_google = 'buttons_sign_in_google';
  static const buttons_sign_in_apple = 'buttons_sign_in_apple';
}

abstract class Locales {

  static const en_US = {
   'buttons_login': 'Login',
   'buttons_sign_in': 'Sign-in',
   'buttons_logout': 'Logout',
   'buttons_sign_in_fb': 'Sign-in with Facebook',
   'buttons_sign_in_google': 'Sign-in with Google',
   'buttons_sign_in_apple': 'Sign-in with Apple',
  };
  static const pt_BR = {
   'buttons_login': 'Entrar',
   'buttons_sign_in': 'Cadastrar-se',
   'buttons_logout': 'Sair',
   'buttons_sign_in_fb': 'Entrar com o Facebook',
   'buttons_sign_in_google': 'Entar com o Google',
   'buttons_sign_in_apple': 'Entar com a  Apple',
  };

}

```

now just add the line in GetMaterialApp

```dart

    GetMaterialApp(
      ...
      translationsKeys: AppTranslation.translations,
      ...
    )
```

### Generate model example

Create the json model file in the assets/models/user.json<br/>

input: <br/>

```json
{
  "name": "",
  "age": 0,
  "friends": ["", ""]
}
```

Run :

```dart
vui generate model on home with assets/models/user.json
```

output:

```dart
class User {
  String name;
  int age;
  List<String> friends;

  User({this.name, this.age, this.friends});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    age = json['age'];
    friends = json['friends'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['age'] = this.age;
    data['friends'] = this.friends;
    return data;
  }
}

```

### Separator file type

One day a user asked me, if it was possible to change what the final name of the file was, he found it more readable to use: `my_controller_name.controller.dart`, instead of the default generated by the cli: `my_controller_name_controller. dart` thinking about users like him we added the option for you to choose your own separator, just add this information in your pubsepc.yaml

Example:

```yaml
vui_cli:
  separator: "."
```

### Are your imports disorganized?

To help you organize your imports a new command was created: `vui sort`, in addition to organizing your imports the command will also format your dart file. thanks to [dart_style](https://pub.dev/packages/dart_style).
When using vui sort all files are renamed, with the [separator](#separator-file-type).
To not rename use the `--skipRename` flag.

You are one of those who prefer to use relative imports instead of project imports, use the `--relative` option. vui_cli will convert.

### Internationalization of the cli

CLI now has an internationalization system.

to translate the cli into your language:

1. create a new json file with your language, in the [tranlations](/translations) folder
2. Copy the keys from the [file](/translations/en.json), and translate the values
3. send your PR.

TODO:

- Support for customModels
- Include unit tests
- Improve generated structure
- Add a backup system
