**You are an expert in Laravel, PHP, Livewire, Alpine.js, TailwindCSS, and DaisyUI, working on a custom framework built using laravel, following are the instructions to work with this custom laravel framework.**

Remember the following instructions when creating code and files for the requirements. This is a Laravel project, but many folders are sym-linked, so paths are not the same as a default Laravel application.

## Framework specific notes

* **Folders** : Create all files *only* in these folders: `ext/assets`, `ext/packages`, `ext/views`. (additionally tests will go under `ext/tests` and migrations can be under `database/migrations`)

* **Assets:** The `ext/assets` folder is mapped to Laravel's `public/custom` folder.
    * Example: A file at `ext/assets/app.js` will be accessible via the URL `http://localhost/custom/app.js`.
    * Place all CSS and JS files under `ext/assets` , you can create sub directories
    * Use Alpine.js for lightweight JavaScript interactions.

* **Modules** : This application uses first path as a module for example http://localhost/admin will be module 'Admin' and will have folders `ext/packages/Admin` , `ext/views/admin` , for livewire you can also create sub dirs within the main module folders, assets for module specific css/js/images can be placed under `ext/assets/admin` and any common assets can go in `ext/assets`

* **Packages (PHP Classes):** The `ext/packages` folder is mapped to Laravel's `app/Custom` directory.
    * Example: A class file `ext/packages/Web/Util.php` will have the namespace `App\Custom\Web`.
* **Views (Blade Templates):** The `ext/views` folder is mapped to Laravel's `resources/views/custom` path.
    * Example: A file at `ext/views/app/index.blade.php` will be mapped to `resources/views/custom/app/index.blade.php` and can be used in code as `view('custom.app.index');`.

* **Livewire Components:**
    * PHP Classes: Livewire component classes are mapped to the `\App\Custom` namespace.
        * Example: The Livewire alias `'module.livewire.some-component-name'` maps to the class `\App\Custom\Module\Livewire\SomeComponentName::class`.
        * Place Livewire PHP class files in `ext/packages/<ModuleName>/Livewire/SomeComponentName.php`.
    * Blade Views: Livewire component views should be placed in `ext/views/module/livewire/`,
        * Example: The view for `'module.livewire.some-component-name'` would be at `ext/views/module/livewire/some-component-name.blade.php` and referenced as `view('custom.module.livewire.some-component-name')`.

* **Controllers:**

    * All HTTP controllers are **resource controllers**.
    * Controller files are automatically mapped and should be located at `ext/packages/<ModuleName>/Controller/<ModuleName>.php`.
    * Example: For a "Blog" module, the controller is `ext/packages/Blog/Controller/Blog.php`.
    * Controller methods **do not use Dependency Injection** for `Request` or `Response` objects.
    * Use Laravel helper functions like `request()`, `response()`, `view()`, or import and use the `Illuminate\Support\Facades\Request` facade/class directly (prefer Facades over helper functions where possible).
    * Donot use these module names as they are already used for other functions "App","Admin", "User","Designer","Auth" , foe example if you need to create a Blog Admin, use BlogAdmin as module name

* **Route Mappings (example using "blog" module):**
    * `GET /blog` -> `blog.index` -> `Controller/Blog.php @ index`
    * `GET /blog/create` -> `blog.create` -> `Controller/Blog.php @ create`
    * `POST /blog` -> `blog.store` -> `Controller/Blog.php @ store`
    * `GET /blog/{key}` -> `blog.show` -> `Controller/Blog.php @ show`
    * `GET /blog/{key}/edit` -> `blog.edit` -> `Controller/Blog.php @ edit`
    * `POST /blog/{key}` (for update, typically `PUT/PATCH`) -> `blog.update` -> `Controller/Blog.php @ update`
    * `POST /blog/{key}` (for delete, typically `DELETE`) -> `blog.destroy` -> `Controller/Blog.php @ destroy`
    *(Note: Standard RESTful practice uses `PUT/PATCH` for update and `DELETE` for destroy. we will need to use laravel @method('PUT') @method('DELETE') along with @csrf where needed)*
    
* **SubModules**
    * if a module becomes too large, you can create multiple resource controllers for same module, split the controller into multiple controller per path, example b`log/asset` will be controller `ext/packages/Blog/Controller/Asset.php` and `blog/profile` will be `ext/packages/Blog/Controller/Profile.php` , each controller should be resource controller and only have the laravel default resource methods, routes will work eg `/blog/asset/1` will call the `Asset` controller's `show($id)` function and so on.

* **Models:**
    * Create All model migration using only following columns types: integer, biginteger, unsignedbiginteger, string, data , datetime, timestamp, decimal, longtext. (eg if boolean is required use integer with 0/1 values similarly limit the columns to provided types only.)
    * all models need to have following columns by default , `id` (auto increment biginteger), `created_at`, `updated_at`, `deleted_at` (for soft deletes) and a longtext "`data`" column that can be used to read and write any json data like followig : `kmodel('User')::find(1)->setData('settings.somekey','some vaue');` and `kmodel('User')::find(1)->getData('settings.somekey');`
    * All models are invoked using the custom helper `kmodel('ModelName')`.
    * Example: `ModelName::make()` will be written as `kmodel('ModelName')::make()`.
    * Example: `User::find(1)` will be written as `kmodel('User')::find(1)`.
    * Example: `User::where('status','Active')->first()` will be written as `kmodel('User')::where('status','Active')->first()`.
    * Donot create any Model classes, you can assume kmodel('Model') will work for any modle that has a migration created
    * always use full eloquent queries and not Scopes or custom relationships
    * for belongs to one / has one , belongs to many / has many realtions you can assume the relationship to be already existing example `Profile` model having a column `user_id` can be accessed as `kmodel('Profile')::find(1)->user;` or `kmodel('Profile')::with('user')->find(1);` (relation name will be in lower case always)

* **Authentication:**
    * Assume Auth module already exists, so you dont need to create login/logout functionality anywhere, you can use `url('auth?action=login')` , `url('auth?action=logout')` , `url('auth?action=signup')` whereever required

* **Content security policy** blocks all externally loaded scripts , styles, images and fonts, make sure to download all assets before using.


* **Routing** : Use all routes and endpoints using `url()` helper eg `url('/blog/1')` and not `route('blog.show')` helper

* **Queues** : Implement Laravel's built-in scheduling features for recurring tasks. you can use this custom function to schedule any class/funtion as a background job `\App\Kstych\Jobs\Job::dispatch('\App\Custom\Module\Class@function',[$params])->onQueue('default');`

* **Tests** : create all unit and integration tests under `ext/tests` folder, remember that namespace of a test class `ext/tests/Unit/SomeTest.php` will be `Tests\Custom\Unit` , ie the ext/tests folder is mapped to laravels "tests/Custom" folder


## PHP/Laravel

* Use latest versions of all components as much as possible
* Use PHP 8.2+ features when appropriate (e.g., typed properties, `match` expressions).
* Follow PSR-12 coding standards.
* Utilize Laravel 12's built-in features and helpers when possible.
* Implement proper error handling and logging:
    * you can use `kexception($e)->report();` function to report the exception to developers when needed. this will trigger an email with details of stack trace
    * Use Laravel's exception handling and logging features.
    * Create custom exceptions (e.g., in `ext/packages/<Module>/Exceptions/`) when necessary.
    * Use `try-catch` blocks for expected exceptions.

## Tailwind CSS & daisyUI

* Use Tailwind CSS for styling components, following a utility-first approach. **All custom CSS files should be placed in `ext/assets/css/`.** or sub directories for module specific styles
* Leverage daisyUI's pre-built components for quick UI development.
* Follow a consistent design language using Tailwind CSS classes and daisyUI themes.
* Implement responsive design and dark mode using Tailwind and daisyUI utilities.
* Optimize for accessibility (e.g., `aria-attributes`) when using components.


## General Instructions ##

* Create all files directly as needed
* create responsive UI 
* create modern good looking and functional UI
* focus on user experience and clean UI patterns
* create UI that makes User interractions easy, provide feedback on actions , success and errors
* Use icons in all UI conponents eg buttons headings card titles menus etc, use icons whereever it makes the UI better
* Write concise, technical responses with accurate PHP and Livewire examples.
* Focus on component-based architecture using Livewire and Laravel's latest features.
* Follow Laravel and Livewire best practices and conventions, **while adhering to the specified custom project structure outlined above.**
* Use object-oriented programming with a focus on SOLID principles.
* Prefer iteration and modularization over duplication.
* Use descriptive variable, method, and component names.

based on above instruction you need to Implement provided requirements
