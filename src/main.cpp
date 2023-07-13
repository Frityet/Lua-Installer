#include <filesystem>
#include <qcoreapplication.h>
#include <qapplication.h>
#include <QtWidgets/QWizard>

#include "pages/Lua.hpp"
#include "pages/Luarocks.hpp"

int main(int argc, char *argv[])
{
    auto app = QApplication(argc, argv);

    auto wizard = QWizard();

    auto lua_page = pages::Lua();
    auto luarocks_page = pages::Luarocks();
    wizard.addPage(&lua_page);
    wizard.addPage(&luarocks_page);

    wizard.setFixedSize(640, 480);
    wizard.setWindowTitle("Lua Installer");
    wizard.setWizardStyle(QWizard::ModernStyle);
    wizard.setOption(QWizard::NoBackButtonOnStartPage);
    wizard.setOption(QWizard::NoDefaultButton);
    wizard.show();

    return app.exec();
}
