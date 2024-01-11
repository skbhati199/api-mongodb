import { Column, Entity, ObjectId, ObjectIdColumn, PrimaryGeneratedColumn } from 'typeorm';


@Entity()
export class User {
    @ObjectIdColumn()
    id: ObjectId;

    @Column()
    name: string;

    @Column({ default: true})
    isActive: boolean;
}
