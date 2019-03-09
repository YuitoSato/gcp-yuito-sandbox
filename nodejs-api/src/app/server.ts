import express from 'express';

const app = express();

app.get('/', (req: express.Request, res: express.Response, next: express.NextFunction) => {
  return res.send('Hello World!!!!!');
});

app.listen(3000, () => { console.log('Listen to 3000 port...'); });

export default app;
