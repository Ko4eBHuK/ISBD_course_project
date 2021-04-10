CREATE INDEX robot_id_index ON robot USING HASH (id);
CREATE INDEX rating_table_robot_id_index ON rating_table USING HASH (robot_id);