# How to install Windows ADK

1. Navigate to the [Download and install the Windows ADK](https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install) website.

2. Download **both** the *Windows ADK* **and** the *Windows PE add-on*.

    [<img src="./images/windows_adk/Download.png" width="75%" />](./images/windows_adk/Download.png)

3. Start the Windows ADK setup (adksetup.exe) first, use the default settings,  
    and install only the *Deployment Tools* feature in the fourth step.

    [<img src="./images/windows_adk/Step_1.png" width="75%" />](./images/windows_adk/Step_1.png)
    [<img src="./images/windows_adk/Step_2.png" width="75%" />](./images/windows_adk/Step_2.png)
    [<img src="./images/windows_adk/Step_3.png" width="75%" />](./images/windows_adk/Step_3.png)
    [<img src="./images/windows_adk/Step_4.png" width="75%" />](./images/windows_adk/Step_4.png)
    [<img src="./images/windows_adk/Step_5.png" width="75%" />](./images/windows_adk/Step_5.png)

4. Start the Windows PE add-on setup (adkwinpesetup.exe) second, and use the default settings.

    [<img src="./images/windows_adk/PE_Step_1.png" width="75%" />](./images/windows_adk/PE_Step_1.png)
    [<img src="./images/windows_adk/PE_Step_2.png" width="75%" />](./images/windows_adk/PE_Step_2.png)
    [<img src="./images/windows_adk/PE_Step_3.png" width="75%" />](./images/windows_adk/PE_Step_3.png)
    [<img src="./images/windows_adk/PE_Step_4.png" width="75%" />](./images/windows_adk/PE_Step_4.png)
    [<img src="./images/windows_adk/PE_Step_5.png" width="75%" />](./images/windows_adk/PE_Step_5.png)

5. The installation is finished at this point, but you can verify that everything went well by
    checking if the `dism.exe` exists in the right place, assuming you installed Windows ADK to the default path.

    ```
    C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM\dism.exe
    ```
