-- Nhân viên (Employees)
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    position VARCHAR(50),
    department VARCHAR(50),
    hire_date DATE,
    status ENUM('Active', 'Inactive') DEFAULT 'Active'
);

-- Nhà cung cấp (Suppliers)
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(200) NOT NULL,
    contact_person VARCHAR(100),
    phone_number VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    tax_code VARCHAR(50),
    status ENUM('Active', 'Inactive') DEFAULT 'Active'
);

-- Danh mục sản phẩm (Product Categories)
CREATE TABLE Product_Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_category_id INT,
    FOREIGN KEY (parent_category_id) REFERENCES Product_Categories(category_id)
);

-- Sản phẩm (Products)
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_code VARCHAR(50) UNIQUE NOT NULL,
    product_name VARCHAR(200) NOT NULL,
    category_id INT,
    unit VARCHAR(50),
    min_stock_level INT,
    max_stock_level INT,
    purchase_price DECIMAL(15,2),
    sale_price DECIMAL(15,2),
    description TEXT,
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    FOREIGN KEY (category_id) REFERENCES Product_Categories(category_id)
);

-- Kho (Warehouses)
CREATE TABLE Warehouses (
    warehouse_id INT PRIMARY KEY AUTO_INCREMENT,
    warehouse_name VARCHAR(100) NOT NULL,
    location VARCHAR(200),
    manager_id INT,
    contact_number VARCHAR(20),
    FOREIGN KEY (manager_id) REFERENCES Employees(employee_id)
);

-- Tồn kho (Inventory)
CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    warehouse_id INT,
    product_id INT,
    current_quantity DECIMAL(15,2) DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    UNIQUE KEY (warehouse_id, product_id)
);

-- Phiếu nhập kho (Goods Receipt)
CREATE TABLE Goods_Receipt (
    receipt_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT,
    employee_id INT,
    receipt_date DATE NOT NULL,
    total_amount DECIMAL(15,2),
    status ENUM('Pending', 'Completed', 'Canceled') DEFAULT 'Pending',
    notes TEXT,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- Chi tiết phiếu nhập kho (Goods Receipt Details)
CREATE TABLE Goods_Receipt_Details (
    receipt_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    receipt_id INT,
    product_id INT,
    quantity DECIMAL(15,2) NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    total_price DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (receipt_id) REFERENCES Goods_Receipt(receipt_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Phiếu xuất kho (Goods Issue)
CREATE TABLE Goods_Issue (
    issue_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    issue_date DATE NOT NULL,
    total_amount DECIMAL(15,2),
    status ENUM('Pending', 'Completed', 'Canceled') DEFAULT 'Pending',
    destination VARCHAR(200),
    notes TEXT,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- Chi tiết phiếu xuất kho (Goods Issue Details)
CREATE TABLE Goods_Issue_Details (
    issue_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    issue_id INT,
    product_id INT,
    quantity DECIMAL(15,2) NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    total_price DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (issue_id) REFERENCES Goods_Issue(issue_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Kiểm kê kho (Inventory Audit)
CREATE TABLE Inventory_Audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    warehouse_id INT,
    employee_id INT,
    audit_date DATE NOT NULL,
    status ENUM('Planned', 'In Progress', 'Completed') DEFAULT 'Planned',
    notes TEXT,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- Chi tiết kiểm kê kho (Inventory Audit Details)
CREATE TABLE Inventory_Audit_Details (
    audit_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    audit_id INT,
    product_id INT,
    system_quantity DECIMAL(15,2),
    physical_quantity DECIMAL(15,2),
    difference DECIMAL(15,2),
    notes TEXT,
    FOREIGN KEY (audit_id) REFERENCES Inventory_Audit(audit_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
