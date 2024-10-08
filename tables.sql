CREATE TABLE branch(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(100) NOT NULL,
    timezone VARCHAR(50) NOT NULL,
    phone_number VARCHAR(16) NOT NULL,
    status SMALLINT NOT NULL,
    /* 
        0. open
        1. closed
        2. acceptance
        3. overordered
    */
    qr CHAR(64) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by_id INTEGER NOT NULL
);

CREATE TABLE branch_schedule(
    branch_id INTEGER NOT NULL,
    status SMALLINT NOT NULL,
    /* 
        0. Open according to schedule
        1. Closed all day
    */
    day SMALLINT NOT NULL,
    /* 
        0. Monday
        ...
        6. Sunday
    */
    start_time TIME NOT NULL,
    end_time TIME NOT NULL
);

CREATE TABLE branch_items(
    id SERIAL PRIMARY KEY,
    branch_id INTEGER NOT NULL,
    item_id INTEGER NOT NULL,
    shelf_amount JSONB NOT NULL,
    expires_date TIMESTAMP NOT NULL,
    is_sale BOOLEAN NOT NULL,
    price FLOAT NOT NULL,
    sale_price FLOAT NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by_id INTEGER NOT NULL
);

CREATE TABLE branch_shelfs(
    id SERIAL PRIMARY KEY,
    branch_id INTEGER NOT NULL,
    name VARCHAR(50) NOT NULL, -- TODO: Max length 50!?
    storage_type_id INTEGER NOT NULL,
    is_disabled BOOLEAN NOT NULL,
    qr CHAR(64) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by_id INTEGER NOT NULL
);





CREATE TABLE acceptance(
    id SERIAL PRIMARY KEY,
    branch_id INTEGER NOT NULL,
    items JSONB NOT NULL, /* make some marker for accepted items */
    is_finished BOOLEAN NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by_id INTEGER NOT NULL
);




CREATE TABLE item(
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(350) NOT NULL,
    ingredients VARCHAR(350) NOT NULL,
    weight INTEGER NOT NULL,
    product_type_id INTEGER NOT NULL,
    storage_type_id INTEGER NOT NULL,
    picture_uuid CHAR(36) NOT NULL,
    barcode CHAR(64) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by_id INTEGER NOT NULL
);

CREATE TABLE storage_type(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    /* 
        ambient shelf
        fridge shelf
        frozen shelf
        egg shelf
        ...
    */
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by_id INTEGER NOT NULL
);

CREATE TABLE product_type(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    /* 
        milk
        alcohol
        drink
        ...
    */
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by_id INTEGER NOT NULL
);




CREATE TABLE user_(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone_number VARCHAR(16) NOT NULL,
    password CHAR(60) NOT NULL,
    payment_info JSONB NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_disabled BOOLEAN NOT NULL
);

CREATE TABLE worker(
    id SERIAL PRIMARY KEY,
    branch_id INTEGER NOT NULL,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone_number VARCHAR(16) NOT NULL,
    role_id INTEGER NOT NULL,
    /* 
        0. technical director
        1. executive director
        2. manager
        3. warehouse worker
        4. deliveryman
        5. technical support
        6. customer support
    */
    status SMALLINT NOT NULL,
    /*
        Deliveryman: 
        0. available
        1. returning
        2. break
        3. handling over orders
        4. on the way to client
        5. picking up order
        Worker:
        0. available
        1. not available
        2. break
        3. collects and prepare order
    */
    is_disabled BOOLEAN NOT NULL,
    qr CHAR(64) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by_id INTEGER NOT NULL
);





CREATE TABLE operation( /* add all operations here - write logic of text in every operation functions */
    id SERIAL PRIMARY KEY,
    branch_id INTEGER NOT NULL,
    description VARCHAR(250) NOT NULL,
    created_by_id INTEGER NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);





CREATE TABLE order_(
    id SERIAL PRIMARY KEY,
    branch_id INTEGER NOT NULL,
    number VARCHAR(50) NOT NULL, -- ?
    items JSONB NOT NULL,
    status SMALLINT NOT NULL,
    /* 
        0. awaiting preparation
        1. preparing
        2. ready for pickup
        3. delivering
        4. delivered
        5. returned
        6. partly returned
        7. not active
    */
    user_id INTEGER NOT NULL, -- ?
    delivery_address VARCHAR(150) NOT NULL,
    worker_id INTEGER NOT NULL,
    worker_start_time TIMESTAMP NOT NULL,
    worker_end_time TIMESTAMP NOT NULL,
    deliveryman_id INTEGER NOT NULL, 
    deliveryman_start_time TIMESTAMP NOT NULL,
    deliveryman_end_time TIMESTAMP NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);