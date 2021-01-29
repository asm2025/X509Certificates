# X509Certificates
Solve the ever-annoying self-signed SSL X509 certificate with IIS and IIS express.

What works is the doing following (assuming you are using localhost):

1. Make sure you have Git installed and added to the environment path.
2. Make a folder to contain the newly generated files. i.e. [PATH]\localhost
3. Open a command prompt running with admin privileges.
4. Navigate to the folder you created from step 2. i.e. `cd /d "[PATH]\localhost"`
5. Run the following commands:
	1. `openssl req -new -sha256 -x509 -nodes -days 1825 -subj "/CN=localhost" -config ..\openssl.cfg -extensions v3_req -newkey rsa:2048 -keyout localhost.key -out localhost.csr`
	2. `cat localhost.key localhost.csr > localhost.tmp`
	3. `openssl pkcs12 -export -inkey localhost.key -in localhost.tmp -out localhost.pfx`

**IMPORTANT:**

Note the command line switch -config ..\openssl.cfg. Change this path to the correct location if needed. You can edit the section [alt_names] to change them or add more settings. The -extensions v3_req corresponds to the section name in the CFG file.

Now you have 3 files:

localhost.key, localhost.csr, localhost.pfx.

the PFX file can be used to import the certificate into both Personal and Trusted Root. You'll need the certificate to be imported to BOTH personal and Trusted Root of the local computer (not the current user) for the IIS and IIS express assignments.

The thumbprint can be obtained by viewing the certificate. Running certmgr.msc or mmc.exe > [Store] > [Open Certificate] > Details Tab > Thumbprint property.

**For IIS:**

Add the CSR file to the Server Certificates. Note the certificate hash column.
Then for each site, Edit the site binding to add a new https configuration with the new certificate.

**For IIS express:**

Run the command:

    ..\iisexadmin.bat [CERT THUMPRINT]
assuming you're still in the certificate folder or navigate to the correct the path.

or Run the command:

    ..\iisexcert.bat [CERT THUMPRINT] [IIS APPID]

or run the power shell command:
    powershell -executionPolicy bypass .\iisexcert.ps1 -thumprint [CERT THUMPRINT] -appid [IIS APPID]

**For Angular:**

Add a folder to contain the CSR and KEY files at the same level as the Angular.json file. I will use ssl in this example.

Then edit the Angular.json file server section under projects > architect > serve:

    "serve": {
		"builder": ...,
		"options": {
			"browserTarget": ...,
			"ssl": true,
			"sslCert": "ssl/localhost.csr",
			"sslKey": "ssl/localhost.key",
			.
			.
			.
		},
    }

Other front end cli may have similar options to set the SSL certificate.

Helpful links

[https://stackoverflow.com/questions/14953132/iis-7-error-a-specified-logon-session-does-not-exist-it-may-already-have-been](https://stackoverflow.com/questions/14953132/iis-7-error-a-specified-logon-session-does-not-exist-it-may-already-have-been)

[https://www.scottbrady91.com/OpenSSL/Creating-RSA-Keys-using-OpenSSL](https://www.scottbrady91.com/OpenSSL/Creating-RSA-Keys-using-OpenSSL)

[https://improveandrepeat.com/2020/05/how-to-change-the-https-certificate-in-iis-express/](https://improveandrepeat.com/2020/05/how-to-change-the-https-certificate-in-iis-express/)

[https://stackoverflow.com/questions/59128101/iis-10-import-ssl-certificate-using-powershell-a-specified-logon-session-do](https://stackoverflow.com/questions/59128101/iis-10-import-ssl-certificate-using-powershell-a-specified-logon-session-do)

[https://www.hanselman.com/blog/working-with-ssl-at-development-time-is-easier-with-iisexpress](https://www.hanselman.com/blog/working-with-ssl-at-development-time-is-easier-with-iisexpress)

[https://stackoverflow.com/questions/30977264/subject-alternative-name-not-present-in-certificate](https://stackoverflow.com/questions/30977264/subject-alternative-name-not-present-in-certificate)

[https://medium.com/@rubenvermeulen/running-angular-cli-over-https-with-a-trusted-certificate-4a0d5f92747a](https://medium.com/@rubenvermeulen/running-angular-cli-over-https-with-a-trusted-certificate-4a0d5f92747a)

[https://stackoverflow.com/questions/43676993/how-do-i-change-my-iis-express-ssl-certificate-for-one-that-will-work-with-chrom](https://stackoverflow.com/questions/43676993/how-do-i-change-my-iis-express-ssl-certificate-for-one-that-will-work-with-chrom)
 