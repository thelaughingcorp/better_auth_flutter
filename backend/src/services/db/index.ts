import { drizzle } from "drizzle-orm/node-postgres";
import { account, session, user, verification } from "./schema/auth";

export const db = drizzle(process.env.DATABASE_URL!, {
  schema: {
    user,
    session,
    account,
    verification,
  },
});
