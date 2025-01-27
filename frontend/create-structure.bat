@echo off
echo Creating frontend directory structure...

REM Public yapısı
mkdir "public\assets" "public\assets\fonts" "public\assets\images" "public\assets\icons"
type nul > "public\index.html"
type nul > "public\manifest.json"

REM API yapısı
mkdir "src\api\endpoints" "src\api\interceptors" "src\api\types"
mkdir "src\services\auth" "src\services\process" "src\services\task"

REM Components yapısı
mkdir "src\components\common\buttons" "src\components\common\inputs" "src\components\common\modals"
mkdir "src\components\common\data-display" "src\components\common\feedback" "src\components\common\navigation"
mkdir "src\components\layout\header" "src\components\layout\sidebar" "src\components\layout\footer"
mkdir "src\components\forms\inputs" "src\components\forms\validation" "src\components\forms\builders"
mkdir "src\components\tables\data-grid" "src\components\tables\filters" "src\components\tables\custom"
mkdir "src\components\charts\bar" "src\components\charts\line" "src\components\charts\pie"

REM Containers yapısı
mkdir "src\containers\dashboards\analytics\components" "src\containers\dashboards\analytics\hooks" "src\containers\dashboards\analytics\utils"
mkdir "src\containers\dashboards\workflow\components" "src\containers\dashboards\workflow\hooks" "src\containers\dashboards\workflow\utils"
mkdir "src\containers\processes\list\components" "src\containers\processes\editor\components"
mkdir "src\containers\tasks\list\components" "src\containers\tasks\detail\components"
mkdir "src\containers\reports\performance\components" "src\containers\reports\audit\components"
mkdir "src\containers\auth\login\components" "src\containers\auth\register\components"
mkdir "src\containers\settings\profile\components" "src\containers\settings\preferences\components"

REM State Management yapısı
mkdir "src\redux\features" "src\redux\actions" "src\redux\selectors" "src\redux\store" "src\redux\middleware" "src\redux\types"
mkdir "src\context\theme\providers" "src\context\auth\providers"
mkdir "src\hooks\common" "src\hooks\form" "src\hooks\api" "src\hooks\auth"

REM Styles yapısı
mkdir "src\assets\styles\components" "src\assets\styles\layouts" "src\assets\styles\themes" "src\assets\styles\variables"
mkdir "src\assets\themes\light" "src\assets\themes\dark"
mkdir "src\assets\images\logos" "src\assets\images\backgrounds"
mkdir "src\assets\icons\menu" "src\assets\icons\actions"

REM i18n yapısı
mkdir "src\i18n\config" "src\i18n\locales\en" "src\i18n\locales\tr"
mkdir "src\i18n\translations\en\common" "src\i18n\translations\tr\common"

REM Tests yapısı
mkdir "src\tests\unit\components" "src\tests\unit\containers" "src\tests\unit\hooks"
mkdir "src\tests\integration\api" "src\tests\integration\flows" "src\tests\integration\auth"
mkdir "src\tests\e2e\scenarios" "src\tests\e2e\fixtures" "src\tests\e2e\support"

REM Config yapısı
mkdir "src\config\constants" "src\config\environment" "src\config\api"
type nul > "src\config\constants\index.ts"
type nul > "src\config\environment\index.ts"
type nul > "src\config\api\index.ts"

REM Utils yapısı
mkdir "src\utils\formatters" "src\utils\validators" "src\utils\helpers" "src\utils\types"

REM Performance yapısı
mkdir "src\performance\monitoring" "src\performance\optimization" "src\performance\metrics"

REM Security yapısı
mkdir "src\security\encryption" "src\security\authentication" "src\security\authorization"

REM Error yapısı
mkdir "src\errors\handlers" "src\errors\boundaries" "src\errors\types"

REM PWA yapısı
mkdir "src\pwa\service-workers" "src\pwa\offline" "src\pwa\cache"
type nul > "src\pwa\service-workers\service-worker.ts"

REM Accessibility yapısı
mkdir "src\a11y\components" "src\a11y\hooks" "src\a11y\utils"

REM Analytics yapısı
mkdir "src\analytics\trackers" "src\analytics\events" "src\analytics\providers"

REM Real-time yapısı
mkdir "src\realtime\socket" "src\realtime\streams" "src\realtime\hooks"

REM SEO yapısı
mkdir "src\seo\meta" "src\seo\schemas" "src\seo\components"

REM Media yapısı
mkdir "src\media\video\components" "src\media\video\hooks"
mkdir "src\media\audio\components" "src\media\audio\hooks"

REM Print yapısı
mkdir "src\print\templates" "src\print\generators" "src\print\utils"

REM Collaboration yapısı
mkdir "src\collaboration\shared" "src\collaboration\sync" "src\collaboration\hooks"

echo Directory structure created successfully!
pause
