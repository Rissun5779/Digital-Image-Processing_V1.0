import hashlib;

s  = hashlib.sha1();
option = input("1.登入 2. 註冊");
if option=="1":
  f = open('HashPasswd.txt','r');
  passwd_list = f.readlines();
  passwd = input("請輸入密碼");  

  s.update(passwd.encode("utf-8"));
  for passwd_i in passwd_list:
    if s.hexdigest()==passwd_i.strip():
      print("密碼正確");
      break;
    else :
      print("密碼錯誤");
  f.close();
elif option=="2":
  f = open('HashPasswd.txt','a');
  passwd = input("請輸入密碼:");
  s.update(passwd.encode("utf-8"));
  f.write(s.hexdigest()+'\n');
  f.close();
  print("註冊完畢")
  