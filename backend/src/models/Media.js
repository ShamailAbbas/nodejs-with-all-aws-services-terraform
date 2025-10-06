import { DataTypes } from "sequelize";

// Factory function pattern (no undefined sequelize issue)
const MediaModel = (sequelize) => {
  return sequelize.define("Media", {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    title: { type: DataTypes.STRING, allowNull: false },
    description: { type: DataTypes.TEXT },
    url: { type: DataTypes.STRING, allowNull: false },
    type: { type: DataTypes.ENUM("image", "video"), allowNull: false },
  }, {
    tableName: "media",
    timestamps: true,
  });
};

export default MediaModel;
