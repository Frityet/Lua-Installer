#include <filesystem>

#include "Qt.hpp"

#include "pages/Lua.hpp"
#include "pages/Luarocks.hpp"
#include "pages/AdditionalTools.hpp"
#include "pages/Progress.hpp"
int main(int argc, char *argv[])
{
    auto app = QApplication(argc, argv);

    auto wizard = QWizard();

    auto lua_page = pages::Lua();
    auto luarocks_page = pages::Luarocks();
    auto progress_page = pages::Progress();
    bool use_mingw, use_make, use_llvm;
    auto AdditionalTools_page = pages::AdditionalTools(&use_make, &use_mingw, &use_llvm);
    wizard.addPage(&lua_page);
    wizard.addPage(&luarocks_page);
    wizard.addPage(&AdditionalTools_page);
    wizard.addPage(&progress_page);
    wizard.setFixedSize(QSize { 640, 480 });
    wizard.setWindowTitle("Lua Installer");
    wizard.setWizardStyle(QWizard::ModernStyle);
    wizard.setOption(QWizard::NoBackButtonOnStartPage);
    wizard.setOption(QWizard::NoDefaultButton);
    wizard.show();

    return app.exec();
}
