win+R
cmd
����C:\>diskpart

����DISKPART> list disk
�����Ļ���ֻ��һ��Ӳ�̣���ôU��Ӧ����ʾΪDisk 1

����DISKPART> select disk 1
ѡ��U��Ϊ��ǰ����

����DISKPART> clean
��մ���

����DISKPART> create partition primary
����������

����DISKPART> select partition 1
ѡ�����

����DISKPART> active
���������һ��Ҫ������Ȼ����������

����DISKPART> format fs=ntfs quick
���ٸ�ʽ��ΪNTFS�ļ�ϵͳ

����DISKPART> assign letter=[ ]
ָ����꣬�ۣ��ܲ������ִ��̷��ظ���Ҳ�ɲ��Ӳ���ʹ��Ĭ�ϡ�

����DISKPART> exit
�˳�Diskpart����ģʽ��

��ISO��ѹ��U��
