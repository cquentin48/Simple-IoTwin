#pragma once

/**
 * @brief IoTwin instance class
 */
class IoTwin {
 private:
    /**
     * Private constructor (default one)
     */
    IoTwin() = default;

    int i = 3;

 public:
    IoTwin(IoTwin &other) = delete;

    void operator=(const IoTwin &) = delete;

    /**
     * @brief Get the Instance object
     * 
     * @return IoTwin& Class instance
     */
    static IoTwin& GetInstance();

    /**
     * @brief Returns the i counter
     * 
     * @return int i counter
     */
    int getI();
};

