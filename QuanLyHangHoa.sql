CREATE DATABASE QuanLyHangHoa
GO
USE QuanLyHangHoa
GO

CREATE TABLE NHACUNGCAP
(
	MANCC		varchar(5),
	TENNCC	varchar(20), 
	TRANGTHAI 	numeric(2),
	THANHPHO	varchar(30),
	CONSTRAINT PK_NHACUNGCAP PRIMARY KEY (MANCC)
);

CREATE TABLE PHUTUNG
(
	 MAPT		varchar(5),
	 TENPT	varchar(10),
	 MAUSAC	varchar(10),
	 KHOILUONG	float,
	 THANHPHO	 varchar(30),
	 CONSTRAINT PK_PHUTUNG PRIMARY KEY (MAPT) 
);

CREATE TABLE VANCHUYEN
(
	MANCC		varchar(5) ,
	MAPT		varchar(5),
	SOLUONG	numeric(5), 
	CONSTRAINT PK_VANCHUYEN PRIMARY KEY (MANCC,MAPT)
);

ALTER TABLE VANCHUYEN ADD CONSTRAINT FK01_VANCHUYEN FOREIGN KEY (MANCC) REFERENCES NHACUNGCAP (MANCC);
ALTER TABLE VANCHUYEN ADD CONSTRAINT FK02_VANCHUYEN FOREIGN KEY (MAPT) REFERENCES PHUTUNG (MAPT);

INSERT INTO NHACUNGCAP VALUES ('S1','Smith','20','London')
INSERT INTO NHACUNGCAP VALUES ('S2','Jones','10','Paris')
INSERT INTO NHACUNGCAP VALUES ('S3','Blake','30','Paris')
INSERT INTO NHACUNGCAP VALUES ('S4','Clark','20','London')
INSERT INTO NHACUNGCAP VALUES ('S5','Adams','30','Athens')

INSERT INTO PHUTUNG VALUES ( 'P1' , 'Nut' , 'Red' , 12.0 , 'London')
INSERT INTO PHUTUNG VALUES ( 'P2' , 'Bolt' , 'Green', 17.0 , 'Paris')
INSERT INTO PHUTUNG VALUES ( 'P3' , 'Screw' , 'Blue', 17.0 , 'Oslo')
INSERT INTO PHUTUNG VALUES ( 'P4' , 'Screw' , 'Red' , 14.0 , 'London')
INSERT INTO PHUTUNG VALUES ( 'P5' , 'Cam' , 'Blue' , 12.0 , 'Paris')
INSERT INTO PHUTUNG VALUES ( 'P6' , 'Cog' , 'Red' , 19.0 , 'London')

INSERT INTO VANCHUYEN VALUES ('S1','P1',300)
INSERT INTO VANCHUYEN VALUES ('S1','P2',200)
INSERT INTO VANCHUYEN VALUES ('S1','P3',400)
INSERT INTO VANCHUYEN VALUES ('S1','P4',200)
INSERT INTO VANCHUYEN VALUES ('S1','P5',100)
INSERT INTO VANCHUYEN VALUES ('S1','P6',100)
INSERT INTO VANCHUYEN VALUES ('S2','P1',300)
INSERT INTO VANCHUYEN VALUES ('S2','P2',400)
INSERT INTO VANCHUYEN VALUES ('S3','P2',200)
INSERT INTO VANCHUYEN VALUES ('S4','P2',200)
INSERT INTO VANCHUYEN VALUES ('S4','P4',300)
INSERT INTO VANCHUYEN VALUES ('S4','P5',400)

SELECT * FROM VANCHUYEN

--1. Hiển thị thông tin (maNCC, tenNCC, thanhpho) của tất cả nhà cung cấp.
SELECT MANCC, TENNCC, THANHPHO
FROM NHACUNGCAP;

--2. Hiển thị thông tin của tất cả các phụ tùng.
SELECT *
FROM PHUTUNG;

--3. Hiển thị thông tin các nhà cung cấp ở thành phố London.
SELECT *
FROM NHACUNGCAP
WHERE THANHPHO = 'London';

--4. Hiển thị mã phụ tùng, tên và màu sắc của tất cả các phụ tùng ở thành
--phố Paris.
SELECT MAPT, TENPT, MAUSAC
FROM PHUTUNG
WHERE THANHPHO = 'Paris';

--5. Hiển thị mã phụ tùng, tên, khối lượng của những phụ tùng có khối
--lượng lớn hơn 15.
SELECT MAPT, TENPT, KHOILUONG
FROM PHUTUNG
WHERE KHOILUONG > 15;

--6. Tìm những phụ tùng (maPT, tenPt, mausac) có khối lượng lớn hơn 15,
--không phải màu đỏ (red).
SELECT MAPT, TENPT, MAUSAC
FROM PHUTUNG
WHERE KHOILUONG > 15 AND MAUSAC <> 'red';

--7. Tìm những phụ tùng (maPT, tenPt, mausac) có khối lượng lớn hơn 15,
--màu sắc khác màu đỏ (red) và xanh (green).
SELECT MAPT, TENPT, MAUSAC 
FROM PHUTUNG
WHERE KHOILUONG > 15 AND (MAUSAC != 'red' AND MAUSAC != 'green');

--8. Hiển thị những phụ tùng (maPT, tenPT, khối lượng) có khối lượng lớn
--hơn 15 và nhỏ hơn 20, sắp xếp theo tên phụ tùng.
SELECT MAPT, TENPT, KHOILUONG 
FROM PHUTUNG
WHERE (KHOILUONG BETWEEN 15 AND 20) ORDER BY TENPT ASC;

--9. Hiển thị những phụ tùng được vận chuyển bởi nhà cung cấp có mã số S1.
--Không hiển thị kết quả trùng. (sử dụng phép kết).
SELECT DISTINCT PHUTUNG.MAPT, TENPT, MAUSAC 
FROM PHUTUNG JOIN VANCHUYEN 
ON PHUTUNG.MAPT = VANCHUYEN.MAPT 
WHERE VANCHUYEN.MANCC = 'S1'; 

--10. Hiển thị những nhà cung cấp vận chuyển phụ tùng có mã là P1 (sử dụng
--phép kết).
SELECT DISTINCT NHACUNGCAP.MANCC, TENNCC 
FROM NHACUNGCAP JOIN VANCHUYEN 
ON NHACUNGCAP.MANCC = VANCHUYEN.MANCC
WHERE MAPT = 'P1';

--11. Hiển thị thông tin nhà cung cấp ở thành phố London và có vận chuyển
--phụ tùng của thành phố London. Không hiển thị kết quả trùng. (Sử dụng
--phép kết)
SELECT DISTINCT NHACUNGCAP.MANCC, TENNCC
FROM (NHACUNGCAP JOIN VANCHUYEN 
ON NHACUNGCAP.MANCC = VANCHUYEN.MANCC)
JOIN PHUTUNG ON VANCHUYEN.MAPT = PHUTUNG.MAPT
WHERE NHACUNGCAP.THANHPHO = 'London' AND PHUTUNG.THANHPHO = 'London';

--12. Lặp lại câu 9 nhưng sử dụng toán tử IN.
SELECT DISTINCT MAPT, TENPT, MAUSAC 
FROM PHUTUNG 
WHERE MAPT IN (SELECT MAPT 
			   FROM VANCHUYEN 
			   WHERE MANCC = 'S1');

--13. Lặp lại câu 10 nhưng sử dụng toán tử IN
SELECT DISTINCT MANCC, TENNCC 
FROM NHACUNGCAP 
WHERE MANCC IN (SELECT MANCC 
				FROM VANCHUYEN 
				WHERE MAPT = 'P1');

--14. Lặp lại câu 9 nhưng sử dụng toán tử EXISTS
SELECT DISTINCT MAPT, TENPT, MAUSAC 
FROM PHUTUNG
WHERE EXISTS (SELECT MAPT 
			  FROM VANCHUYEN 
			  WHERE MANCC = 'S1');

--15. Lặp lại câu 10 nhưng sử dụng toán tử EXISTS
SELECT MANCC, TENNCC
FROM NHACUNGCAP
WHERE EXISTS (SELECT MANCC 
			  FROM VANCHUYEN
			  WHERE NHACUNGCAP.MANCC = VANCHUYEN.MANCC AND MAPT = 'P1');

--16. Lặp lại câu 11 nhưng sử dụng truy vấn con. Sử dụng toán tử IN.
SELECT DISTINCT MANCC, TENNCC
FROM NHACUNGCAP
WHERE THANHPHO = 'London' AND MANCC IN (SELECT MANCC 
                                           FROM VANCHUYEN 
                                           WHERE MAPT IN (SELECT MAPT 
                                                          FROM PHUTUNG
                                                          WHERE PHUTUNG.THANHPHO = 'London'));

--17. Lặp lại câu 11 nhưng dùng truy vấn con. Sử dụng toán tử EXISTS.
SELECT DISTINCT MANCC, TENNCC
FROM NHACUNGCAP
WHERE THANHPHO = 'London' AND EXISTS (SELECT MANCC 
                                      FROM VANCHUYEN  
                                      WHERE NHACUNGCAP.MANCC = VANCHUYEN.MANCC AND EXISTS (SELECT MAPT
                                                                                           FROM PHUTUNG
                                                                                           WHERE VANCHUYEN.MAPT = PHUTUNG.MAPT AND PHUTUNG.THANHPHO = 'London'));
                     

--18. Tìm nhà cung cấp chưa vận chuyển bất kỳ phụ tùng nào. Sử dụng NOT
--IN.
SELECT DISTINCT MANCC, TENNCC
FROM NHACUNGCAP
WHERE MANCC NOT IN (SELECT MANCC 
					FROM VANCHUYEN);

--19. Tìm nhà cung cấp chưa vận chuyển bất kỳ phụ tùng nào. Sử dụng NOT
--EXISTS.
SELECT DISTINCT MANCC, TENNCC
FROM NHACUNGCAP
WHERE NOT EXISTS (SELECT MANCC 
				  FROM VANCHUYEN 
				  WHERE NHACUNGCAP.MANCC = VANCHUYEN.MANCC);

--20. Tìm nhà cung cấp chưa vận chuyển bất kỳ phụ tùng nào. Sử dụng outer
--JOIN (Phép kết ngoài)
SELECT DISTINCT NHACUNGCAP.MANCC, TENNCC
FROM NHACUNGCAP FULL OUTER JOIN VANCHUYEN ON NHACUNGCAP.MANCC = VANCHUYEN.MANCC
WHERE MAPT IS NULL;

--21. Có tất cả bao nhiêu nhà cung cấp?
SELECT COUNT(MANCC) 'SL NCC' FROM NHACUNGCAP;

--22. Có tất cả bao nhiêu nhà cung cấp ở London?
SELECT COUNT(MANCC) 'SL_NCC_London'
FROM NHACUNGCAP
GROUP BY THANHPHO
HAVING THANHPHO = 'London';

--23. Hiển thị trị giá cao nhất, thấp nhất của trangthai của các nhà cung
--cấp.
SELECT MAX(TRANGTHAI) 'TT_MAX', MIN(TRANGTHAI) 'TT_MIN'
FROM NHACUNGCAP;

--24. Hiển thị giá trị cao nhất, thấp nhất của trangthai trong table
--nhacungcap ở thành phố London.
SELECT MAX(TRANGTHAI) 'MAX_TT', MIN(TRANGTHAI) 'MIN_TT'
FROM NHACUNGCAP
GROUP BY THANHPHO
HAVING THANHPHO = 'London';

--25. Mỗi nhà cung cấp vận chuyển bao nhiêu phụ tùng? Chỉ hiển thị mã nhà
--cung cấp, tổng số phụ tùng đã vận chuyển.
SELECT MANCC, SUM(SOLUONG) 'SL_VANCHUYEN'
FROM VANCHUYEN
GROUP BY MANCC;

--26. Mỗi nhà cung cấp vận chuyển bao nhiêu phụ tùng? Hiển thị mã nhà cung
--cấp, tên, thành phố của nhà cung cấp và tổng số phụ tùng đã vận chuyển

--Cách 1:
SELECT NHACUNGCAP.MANCC, TENNCC, THANHPHO, SUM(SOLUONG) 'SO_LUONG'
FROM NHACUNGCAP JOIN VANCHUYEN
ON NHACUNGCAP.MANCC = VANCHUYEN.MANCC
GROUP BY NHACUNGCAP.MANCC, TENNCC, THANHPHO;
--Cách 2:
SELECT NCC.MANCC,TENNCC,THANHPHO, SUM(SOLUONG) 'TONG SO PHU TUNG'
FROM VANCHUYEN VC, NHACUNGCAP NCC
WHERE VC.MANCC = NCC.MANCC
GROUP BY NCC.MANCC,TENNCC,THANHPHO;

--27. Nhà cung cấp nào đã vận chuyển tổng cộng nhiều hơn 500 phụ tùng? Chỉ
--hiển thị mã nhà cung cấp
SELECT MANCC
FROM VANCHUYEN
GROUP BY MANCC
HAVING SUM(SOLUONG) > 500;

--28. Nhà cung cấp nào đã vận chuyển nhiều hơn 300 phụ tùng màu đỏ (red).
--Chỉ hiển thị mã nhà cung cấp.
SELECT MANCC
FROM VANCHUYEN JOIN PHUTUNG
ON VANCHUYEN.MAPT = PHUTUNG.MAPT
WHERE MAUSAC = 'red' 
GROUP BY MANCC
HAVING SUM(SOLUONG) > 300;

--29. Nhà cung cấp nào đã vận chuyển nhiều hơn 300 phụ tùng màu đỏ (red).
--Hiển thị mã nhà cung cấp, tên, thành phố và số lượng phụ tùng màu đỏ đã
--vận chuyển.
SELECT MANCC, TENNCC, THANHPHO
FROM NHACUNGCAP
WHERE MANCC IN (SELECT MANCC
				FROM VANCHUYEN JOIN PHUTUNG
				ON VANCHUYEN.MAPT = PHUTUNG.MAPT
				WHERE MAUSAC = 'red'
				GROUP BY MANCC
				HAVING SUM(SOLUONG) > 300);

--30. Có bao nhiêu nhà cung cấp ở mỗi thành phố.
SELECT DISTINCT THANHPHO, COUNT(MANCC) 'SL_NhaCungCap'
FROM NHACUNGCAP
GROUP BY THANHPHO;

--31. Nhà cung cấp nào đã vận chuyển nhiều phụ tùng nhất. Hiển thị tên nhà
--cung cấp và số lượng phụ tùng đã vận chuyển.
SELECT DISTINCT TOP 1 TENNCC, SUM(SOLUONG) 'VanChuyenNhieuNhat'
FROM NHACUNGCAP, VANCHUYEN
WHERE NHACUNGCAP.MANCC = VANCHUYEN.MANCC
GROUP BY TENNCC
ORDER BY SUM(SOLUONG) DESC;

--32. Thành phố nào có cả nhà cung cấp và phụ tùng.
SELECT NHACUNGCAP.THANHPHO
FROM NHACUNGCAP, PHUTUNG
WHERE NHACUNGCAP.THANHPHO = PHUTUNG.THANHPHO;

--33. Viết câu lệnh SQL để insert nhà cung cấp mới: S6, Duncan, 30, Paris.
INSERT INTO NHACUNGCAP VALUES('S6', 'Duncan', '30', 'Paris');
SELECT * FROM NHACUNGCAP;

--34. Viết câu lệnh SQL để thay đổi thanh phố S6 (ở câu 33) thành Sydney.
UPDATE NHACUNGCAP SET THANHPHO = 'Sydney' WHERE MANCC = 'S6';
SELECT * FROM NHACUNGCAP;

--35. Viết câu lệnh SQL tăng trangthai của nhà cung cấp ở London lên thêm
--10.
UPDATE NHACUNGCAP SET TRANGTHAI = TRANGTHAI + 10 WHERE THANHPHO  = 'London'
SELECT * FROM NHACUNGCAP;

--36. Viết câu lệnh SQL xoá nhà cung cấp S6
DELETE FROM NHACUNGCAP WHERE MANCC = 'S6';
SELECT * FROM NHACUNGCAP;
